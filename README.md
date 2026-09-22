# YouTube MCP Server

<!-- mcp-name: com.hasdata/youtube -->

A hosted Model Context Protocol (MCP) server that gives Claude, Cursor, Windsurf and any other MCP client four read-only YouTube tools. Search YouTube, read video and channel data, and pull transcripts, with no Google Cloud project and no YouTube Data API key.

**1,000 free credits every month, no card required**, which is 100 YouTube calls.

```
https://mcp.hasdata.com/mcp?apis=youtube
```

[![Glama score](https://glama.ai/mcp/servers/HasData/youtube-mcp/badges/score.svg)](https://glama.ai/mcp/servers/HasData/youtube-mcp)
[![tool contract](https://github.com/HasData/youtube-mcp/actions/workflows/contract.yml/badge.svg)](https://github.com/HasData/youtube-mcp/actions/workflows/contract.yml)
[![MCP](https://img.shields.io/badge/MCP-remote%20%7C%20streamable%20HTTP-6366f1?style=flat-square)](https://modelcontextprotocol.io)
[![Tools](https://img.shields.io/badge/tools-4-10b981?style=flat-square)](#tools)
[![npm](https://img.shields.io/npm/v/@hasdata/youtube-mcp?style=flat-square&logo=npm&label=npm&color=cb3837)](https://www.npmjs.com/package/@hasdata/youtube-mcp)
[![PyPI](https://img.shields.io/pypi/v/hasdata-youtube-mcp?style=flat-square&logo=pypi&logoColor=white&label=PyPI&color=3775a9)](https://pypi.org/project/hasdata-youtube-mcp/)
[![License](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)

## Contents

- [What you need](#what-you-need)
- [Quick start](#quick-start)
- [Example prompts](#example-prompts)
- [Tools](#tools)
- [Errors and failure paths](#errors-and-failure-paths)
- [Pricing, free tier and limits](#pricing-free-tier-and-limits)
- [Tool selection](#tool-selection)
- [How it compares](#how-it-compares)
- [FAQ](#faq)
- [HasData links](#hasdata-links)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## What you need

An MCP client that speaks streamable HTTP with custom headers. A HasData API key from the [dashboard](https://app.hasdata.com/sign-up?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp), free to create. Nothing else. This is a remote server, so the simplest path is a URL and a header, with no container to run and no Google account anywhere in the flow. A stdio-only client can use the `@hasdata/youtube-mcp` (npm) or `hasdata-youtube-mcp` (PyPI) launcher instead.

## Quick start

The server URL is the same for every client. We run it hands-on in Claude Code and Claude Desktop. The other blocks follow each client's own documented format for a remote server.

| Field | Value |
| :--- | :--- |
| URL | `https://mcp.hasdata.com/mcp?apis=youtube` |
| Transport | HTTP, streamable |
| Auth header | `x-api-key: HASDATA_API_KEY` |

Clients with OAuth support can add the same URL as a connector and sign in without putting a key in a config file.

<details>
<summary><b>Claude Code</b></summary>

```bash
claude mcp add --transport http youtube "https://mcp.hasdata.com/mcp?apis=youtube" \
  --header "x-api-key: HASDATA_API_KEY"
```

</details>

<details>
<summary><b>Claude Desktop</b></summary>

Settings, then Connectors, then Add custom connector, then paste `https://mcp.hasdata.com/mcp?apis=youtube` and sign in.

For the config-file route, Claude Desktop loads only local (stdio) servers, so it reaches a remote server through a stdio launcher. The `@hasdata/youtube-mcp` package is that launcher, and it reads the key from the environment. Add this to `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "youtube": {
      "command": "npx",
      "args": ["-y", "@hasdata/youtube-mcp"],
      "env": { "HASDATA_API_KEY": "YOUR_KEY" }
    }
  }
}
```

Python instead of Node? Swap the launcher for the PyPI package, which `uvx` runs without a manual install:

```json
{
  "mcpServers": {
    "youtube": {
      "command": "uvx",
      "args": ["hasdata-youtube-mcp"],
      "env": { "HASDATA_API_KEY": "YOUR_KEY" }
    }
  }
}
```

</details>

<details>
<summary><b>Cursor</b></summary>

`~/.cursor/mcp.json` for every project, or `.cursor/mcp.json` for one:

```json
{
  "mcpServers": {
    "youtube": {
      "url": "https://mcp.hasdata.com/mcp?apis=youtube",
      "headers": { "x-api-key": "HASDATA_API_KEY" }
    }
  }
}
```

</details>

<details>
<summary><b>Windsurf</b></summary>

`~/.codeium/windsurf/mcp_config.json`. Windsurf calls the field `serverUrl`, not `url`:

```json
{
  "mcpServers": {
    "youtube": {
      "serverUrl": "https://mcp.hasdata.com/mcp?apis=youtube",
      "headers": { "x-api-key": "HASDATA_API_KEY" }
    }
  }
}
```

</details>

<details>
<summary><b>Cline</b></summary>

```json
{
  "mcpServers": {
    "youtube": {
      "url": "https://mcp.hasdata.com/mcp?apis=youtube",
      "type": "streamableHttp",
      "headers": { "x-api-key": "HASDATA_API_KEY" },
      "disabled": false
    }
  }
}
```

</details>

<details>
<summary><b>VS Code</b></summary>

`.vscode/mcp.json` in the workspace:

```json
{
  "servers": {
    "youtube": {
      "type": "http",
      "url": "https://mcp.hasdata.com/mcp?apis=youtube",
      "headers": { "x-api-key": "HASDATA_API_KEY" }
    }
  }
}
```

</details>

<details>
<summary><b>Codex CLI</b></summary>

`~/.codex/config.toml`:

```toml
[mcp_servers.youtube]
url = "https://mcp.hasdata.com/mcp?apis=youtube"

[mcp_servers.youtube.headers]
"x-api-key" = "HASDATA_API_KEY"
```

</details>

<details>
<summary><b>Gemini CLI</b></summary>

`~/.gemini/settings.json`:

```json
{
  "mcpServers": {
    "youtube": {
      "httpUrl": "https://mcp.hasdata.com/mcp?apis=youtube",
      "headers": { "x-api-key": "HASDATA_API_KEY" }
    }
  }
}
```

</details>

## Example prompts

Prompts, not code. Paste one in and the agent picks the tool itself. Each is annotated with the calls it takes, because in MCP the model decides how many calls to make and every successful call costs 10 credits.

> Find the ten most viewed videos about the Model Context Protocol from the last month, then pull the transcript of the top one and give me the three claims it makes about tool calling.

*Two calls, 20 credits.*

> Take the channel @GoogleDevelopers. List the tabs it publishes, then summarize the last five uploads and tell me which topics repeat.

*Two calls, 20 credits. Reading a tab you have not seen takes a second call, because the tab list arrives inside the first response.*

> Take this video id, dQw4w9WgXcQ. Get its stats, then check which of its related videos come from the same channel.

*One call, 10 credits. Related videos ride along in the same response.*

> Search YouTube for "web scraping tutorial", sorted by upload date, videos under four minutes only, and give me the chapter titles of each result that has them.

*One call, 10 credits.*

> Pull the German transcript of this video if one exists, and tell me which languages it is available in.

*One call, 10 credits.*

Search takes YouTube's own filter tokens, and an agent narrows by duration, upload date and content type without post-processing. Transcripts arrive with the list of available language tracks, which lets the agent pick one without guessing.

Paging costs a call each time. A research prompt that searches, pages twice, then pulls three transcripts is six calls and 60 credits. The free tier goes further on narrow questions than on open-ended crawls.

## Tools

| Tool | What it returns |
| --- | --- |
| `hasdata_youtube_channel_getYoutubeChannel` | Channel identity (title, description, avatar, banner, country, join date), subscriber and total-view counts, social links, and the items on the requested tab (videos…. 10 credits a call |
| `hasdata_youtube_search_getYoutubeSearchResults` | Searches YouTube for a query and returns the full results page split into `videoResults` (videoId, title, views, length, publish date, chapters, channel info, extensions…. 10 credits a call |
| `hasdata_youtube_transcript_getYoutubeTranscript` | The timed transcript (subtitles) of a YouTube video by its 11-character `videoId`. 10 credits a call |
| `hasdata_youtube_video_getYoutubeVideo` | Title, thumbnail, raw + normalized views and likes, `lengthSeconds`, publish date, category, keywords/tags, `isFamilySafe` / `isUnlisted` flags, the uploading channel…. 10 credits a call |

Four tools, all read-only. Samples below are trimmed from real calls, and the numbers in them move as YouTube updates. Read them as shapes. Each tool name links to its endpoint reference, which carries the full field list.

The samples are the payload, not the whole response. A `tools/call` result carries one text block, and that text is itself JSON holding `url`, `status`, `text` and `json`, with the scraped data under `json`. From a raw JSON-RPC response the path is `result.content[0].text`, parsed, then `.json`. A chat client unwraps that for you and code talking to the endpoint directly does not.

### Get YouTube search results

[`hasdata_youtube_search_getYoutubeSearchResults`](https://docs.hasdata.com/apis/youtube/search?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp)

Searches YouTube and returns the whole results page, split by result type.

| Parameter | Type | Required | Notes |
| :--- | :--- | :--- | :--- |
| `q` | string | yes | Free-text query, exactly as a user would type it |
| `sortBy` | string | | `relevance` by default, plus `date`, `views`, `rating` and `popularity` |
| `date` | string | | Upload window relative to now |
| `length` | string | | Duration bucket, for example `under4` |
| `videoType` | string | | Restrict to one content type |
| `filters__` | array | | Feature flags, combinable |
| `sp` | string | | Raw YouTube `sp` token copied from a search URL. Overrides `sortBy`, `date`, `videoType`, `length` and `filters__` with no warning, so leave those empty when you pass a token |
| `paginationToken` | string | | The `pagination.nextPageToken` from the previous response |
| `gl` / `hl` / `deviceType` | string | | Two-letter country and language codes, and device |

A results page is split across `videoResults`, `shortsResults`, `inlineShortsResults`, `playlistResults`, `channelResults` and `shelves`, with paid placements in `adsResults` and `sponsoredResults`. Which blocks appear depends on the query, and a block with nothing to report is absent, not empty. Test for the key before iterating. `searchInformation` carries the total and `pagination.nextPageToken` is what you feed back as `paginationToken`. Ads never mix into the organic arrays, though there are two of them to skip.

```json
{
  "positionOnPage": 1,
  "videoId": "GuTcle5edjk",
  "title": "you need to learn MCP RIGHT NOW!! (Model Context Protocol)",
  "viewsOriginal": "1.6M views",
  "views": 1653824,
  "length": "38:40",
  "publishedDate": "11 months ago",
  "extensions": ["4K"],
  "chapters": [
    { "title": "Intro", "time": "0:00" },
    { "title": "Problem: LLMs Suck at Accessing Code", "time": "0:40" }
  ],
  "channel": { "name": "NetworkChuck", "verified": true }
}
```

Two things there earn a mention. `views` is a parsed integer next to the `1.6M views` display string and needs no suffix parser. And `chapters` come back inside search results, not only on the video itself, though only some videos carry them.

The [search endpoint reference](https://docs.hasdata.com/apis/youtube/search?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp) lists every `sp` and `filters__` token the endpoint accepts.

### Get YouTube video data

[`hasdata_youtube_video_getYoutubeVideo`](https://docs.hasdata.com/apis/youtube/video?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp)

One video by id.

| Parameter | Type | Required | Notes |
| :--- | :--- | :--- | :--- |
| `v` | string | yes | The 11-character video id from `v=` |
| `gl` / `hl` / `deviceType` | string | | Two-letter country and language codes, and device |

Returns `title`, `thumbnail`, `channel`, `publishedDate`, `lengthSeconds`, `category`, `isFamilySafe` and `isUnlisted`, plus the `relatedVideos`, `endScreenVideos`, `keywords`, `captions`, `music` and `socialLinks` arrays. `description` is an object holding the full text in `content` and a `links` array where every link and hashtag carries `startIndex`, `length`, `text` and `url`. The `text` field holds the link as the author wrote it and `url` holds YouTube's redirect wrapper, which matters if you are pulling sponsor or affiliate destinations out of descriptions.

> Read the parsed field by name per tool before you copy the sample below. Search and channel results put the parsed number in `views` and the display string in `viewsOriginal`. This response inverts it, keeping the string in `views` and the number in `extractedViews`, and the same inversion applies to `likes` and `subscribers`. Get it wrong and `item.views > 100000` compares a string here without ever throwing.

```json
{
  "title": "Rick Astley - Never Gonna Give You Up (Official Video) (4K Remaster)",
  "views": "1,806,075,152 views",
  "extractedViews": 1806075152,
  "likes": "19M",
  "extractedLikes": 19344370,
  "publishedDate": "Oct 24, 2009",
  "lengthSeconds": 214,
  "category": "Music",
  "channel": { "name": "Rick Astley", "subscribers": "4.53M subscribers", "extractedSubscribers": 4530000 }
}
```

### Get YouTube channel data

[`hasdata_youtube_channel_getYoutubeChannel`](https://docs.hasdata.com/apis/youtube/channel?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp)

A channel by id or handle, one tab at a time.

| Parameter | Type | Required | Notes |
| :--- | :--- | :--- | :--- |
| `channelId` | string | yes | Canonical `UC…` id or a `@handle` |
| `tab` | string | | `featured` by default, plus `videos`, `shorts`, `streams`, `playlists`, `posts`, `community`, `podcasts`, `releases`, `about` and `store`. Take a value from this list, not from `availableTabs` in the response |
| `paginationToken` | string | | Token from the previous response |
| `gl` / `hl` / `deviceType` | string | | Two-letter country and language codes, and device |

Returns `channelInfo`, `featuredVideo` and `sections` on the default tab. Other tabs return their own shape. `channelInfo` carries the handle, avatar, banner, description, channel keywords and the channel's `rssUrl`, enough to keep watching a channel without polling it.

> The `availableTabs` array in the sample below holds display labels, and they are not the values `tab` accepts. `Home`, `Live`, `Courses` and `Search` map to no parameter value at all, and the rest need lowercasing. An agent that reads the list and walks each entry fails on the first one.

```json
{
  "channelInfo": {
    "channelId": "UC_x5XG1OV2P6uZZ5FSM9Ttw",
    "name": "Google for Developers",
    "handle": "@GoogleDevelopers",
    "rssUrl": "https://www.youtube.com/feeds/videos.xml?channel_id=UC_x5XG1OV2P6uZZ5FSM9Ttw",
    "isFamilySafe": true,
    "availableTabs": ["Home", "Videos", "Shorts", "Live", "Courses", "Playlists", "Posts", "Search"]
  }
}
```

### Get YouTube video transcript

[`hasdata_youtube_transcript_getYoutubeTranscript`](https://docs.hasdata.com/apis/youtube/transcript?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp)

The timed transcript of a video.

| Parameter | Type | Required | Notes |
| :--- | :--- | :--- | :--- |
| `v` | string | yes | The 11-character video id |
| `languageCode` | string | | BCP-47 code of the track you want |
| `type` | string | | Set to `asr` for the auto-generated track |

> Check `selected` in the response before you trust the language. Asking for a `languageCode` the video does not carry neither fails nor returns empty, it quietly falls back to the default track. Every entry in the list carries `languageName` and `languageCode`, and one language can appear twice, once human-authored and once with `type` set to `asr`.

```json
{
  "transcript": [
    { "startMs": 320, "endMs": 18800, "snippet": "[Music]", "startTimeText": "0:00" },
    { "startMs": 18800, "endMs": 21800, "snippet": "We're no strangers to", "startTimeText": "0:18" }
  ],
  "availableTranscripts": [
    { "languageName": "English", "languageCode": "en" },
    { "languageName": "English", "languageCode": "en", "type": "asr", "selected": true },
    { "languageName": "German (Germany)", "languageCode": "de-DE" },
    { "languageName": "Japanese", "languageCode": "ja" }
  ]
}
```

## Errors and failure paths

Your client almost never sees an HTTP error code from a tool call. The MCP layer answers 200 and puts the failure inside the result, with `isError` set to `true` and the reason as text. The agent reads a message where you might expect a status line.

**A wrong key surfaces as tool output, not as a failed connection.** `tools/list` accepts any non-empty key and returns all four tools, so the client completes its handshake and shows green. The first tool call then comes back with `isError: true` and the text `HasData API error: 401 Unauthorized`. Watch for that string, because nothing earlier in the flow reports the problem.

**A missing key is the one real HTTP error.** Authorization runs before any tool, and the connection itself fails with 401. CORS headers are present, and a browser client reads the status and not an opaque network failure.

**An argument that breaks a tool's schema is rejected before it becomes a scrape.** The server answers with `isError: true` and the text `MCP error -32602: Input validation error`, naming the offending field. Nothing is fetched and nothing is charged. The message names the field but not the accepted values, so the parameter tables above are the reference.

**A call that succeeds and finds nothing is the case that trips people up.** It arrives as an ordinary result with `requestMetadata.status` set to `ok` and the data key simply missing. Nothing in the body says the result was empty. Test for the field you need, not for an error.

**An identifier the platform rejects returns 400** with `requestMetadata.status` set to `error`. A channel handle that does not exist is the usual way to see this.

Results that carry data also carry a `requestMetadata.id` worth quoting in support.

## Pricing, free tier and limits

Every YouTube tool costs **10 credits per successful call**. Response size does not change the price. A full page of search results costs the same as a page with one video.

The free tier is **1,000 credits every month with no card**, which is 100 YouTube calls. It renews with the billing cycle, so a low-volume agent runs on the free tier indefinitely.

Paid plans start at **$59 a month** for 200,000 credits, which is 20,000 calls. The unit price falls with volume, from **$2.95 per 1,000 calls** on the entry plan to **$1.19** on Basic and **$0.83** across the Growth tiers. Current figures live on the [pricing page](https://hasdata.com/prices?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp).

Your plan also sets concurrency. The free tier allows 1 request at a time, Startup 5, Basic 15, and the Growth tiers run from 50 to 500. Handle the overflow case defensively in anything unattended, because an agent that fans out will reach the ceiling before you do.

A request that comes back non-200 is not billed. A successful call that finds nothing is still a call.

## Tool selection

The `apis` query parameter decides which tools your agent sees. Fewer tools means less context spent on tool definitions, and fewer chances for the model to reach for the wrong one.

```
?apis=youtube                    the four tools in this repo
?apis=youtube,google_serp        add Google search
?apis=youtube,tiktok,instagram   a social research bundle
```

The parameter takes provider names like `youtube` and individual API names like `google_maps_search`. Misspelled names are ignored. If every name is wrong the request fails with 400, and the body lists both what it did not recognise and every valid value. Drop the parameter and the same endpoint exposes all 57 HasData tools.

## How it compares

Against the official **YouTube Data API v3**:

| | YouTube Data API v3 | This server |
| :--- | :--- | :--- |
| Setup | Google Cloud project and an API key | One key and one URL |
| Search allowance | "default quota allocation of 100 `search.list` calls" a day, per [Google's getting started guide](https://developers.google.com/youtube/v3/getting-started) | Your plan's credits, 10 per call |
| Transcripts of videos you do not own | `captions.download` "requires the user to have permission to edit the video", per [Google's reference](https://developers.google.com/youtube/v3/docs/captions/download) | Yes, with the language list |
| Chapters in search results | No | Yes |
| Views and likes in search results | Absent, and a second `videos.list` call returns them as strings | Display string and integer in the same response |
| Cost | Free inside the daily quota | Paid past the free tier, 10 credits a call |
| Writes and private data | Uploads, playlists, comments and your own analytics over OAuth | Read-only, public data only |

The last two rows matter. If the daily quota covers your volume and you own the channel you are querying, the official API is the cheaper answer and you should take it.

Most other YouTube MCP servers do transcripts only. This one also searches, reads videos with their engagement numbers, and walks channel tabs, so an agent runs a whole research pass without a second server.

**What this server does not do.** No comments, no channel management, no uploads, no analytics, no private data. It reads what a signed-out visitor can see.

## FAQ

### Is there an official YouTube MCP server?

Google does not publish one. YouTube has no first-party MCP server. Every option is built by somebody else, either around the YouTube Data API v3 or around the public pages. This one is maintained by HasData and reads public pages, which is why it needs no Google credentials.

### What is a YouTube MCP server?

A server that exposes YouTube data as tools an AI client can call. The client sends a tool call over the Model Context Protocol, the server fetches the data and returns structured JSON, and the model works with the result and never sees a page of HTML. This one exposes four tools and runs remotely. The client connects to a URL and starts no local process.

### Do I need a YouTube API key or a Google Cloud project?

No. The only credential is your HasData key. There is no Google Cloud project to create, no quota form to fill in and no OAuth consent screen, because the tools read public YouTube pages and not the YouTube Data API.

### Do I need to host or run anything?

No. This is a remote MCP server on streamable HTTP. Nothing to install, no container to keep warm, no process to restart.

### Is the data live or cached?

Live. Each call fetches the page at request time and carries its own `requestMetadata.id`. Two identical calls are two separate fetches and not a replay of a stored copy. Counters like views and likes track the page, so they move as the page moves.

### What happens when YouTube changes its layout?

Nothing on your side. We track the changes and keep the response schema stable, so field names and types stay put. A field with no value is absent from the item, not present and null. Read optional fields with a default.

### Can I use this together with other HasData APIs?

Yes. The `apis` parameter takes a list, and `?apis=youtube,google_serp` gives your agent the four YouTube tools plus Google search. [Drop the parameter](#tool-selection) and you get everything.

### Can I get a transcript for any video?

Only where the video has one, and `availableTranscripts` tells you what exists before you ask.

### Can I sign in with OAuth instead of pasting a key?

Yes, in clients that support it. Claude Desktop and Cursor can add the endpoint as a connector and sign in. Unattended agents and scripts use the `x-api-key` header.

### Compliance and personal data

HasData accesses publicly available data only. A platform's terms may restrict automated access, and you are responsible for your own compliance. Where the data you collect includes personal information, make sure you have a lawful basis for it under GDPR, CCPA or the equivalent rules in your jurisdiction.

## HasData links

| | |
| :--- | :--- |
| Product page and request builder | [YouTube Scraper API](https://hasdata.com/apis/youtube-scraper-api?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp) |
| Server documentation | [MCP server docs](https://docs.hasdata.com/mcp-server?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp) |
| All 57 tools in one server | [HasData/hasdata-mcp](https://github.com/HasData/hasdata-mcp) |
| Client walkthroughs | [MCP clients and integrations](https://hasdata.com/integrations/mcp?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp) |
| Everything else we scrape | [YouTube Scraper API and 54 more](https://hasdata.com/apis/?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp) |
| Plans and credit costs | [Plans and credit costs](https://hasdata.com/prices?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp) |
| Keys and usage | [HasData dashboard](https://app.hasdata.com?utm_source=github&utm_medium=syndication&utm_campaign=youtube-mcp) |
| Node launcher on npm | [@hasdata/youtube-mcp](https://www.npmjs.com/package/@hasdata/youtube-mcp) |
| Python launcher on PyPI | [hasdata-youtube-mcp](https://pypi.org/project/hasdata-youtube-mcp/) |

## Development

This repository is configuration and documentation for a remote server. There is no build step and nothing to containerize.

The tests in `test/` assert the tool contract, the part that can break without a commit here. They check that `?apis=youtube` returns exactly four tools, that every tool still declares its required parameter, that no name changed, and that the key in use is actually accepted. That last check calls a tool for real and costs 10 credits, which is the price of a canary that can fail for the right reason.

```bash
# macOS and Linux
HASDATA_API_KEY=your_key_here npm test

# Windows PowerShell
$env:HASDATA_API_KEY="your_key_here"; npm test
```

The same suite runs in CI on every push and once a week on a schedule, because the upstream tool list can change without anyone touching this repository. A failure means the tool list moved, the key stopped working, or the endpoint was unreachable, and the assertion message says which.

## Contributing

Corrections to the tool tables and the response samples are the most useful contribution, because those are the parts that drift. Include the call you made and the response you got. Pull requests from forks run the suite without a key, and the live checks skip instead of going red.

## License

MIT. See [LICENSE](LICENSE).
