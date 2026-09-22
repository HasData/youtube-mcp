---
description: What ranks on YouTube for a query, and what the leading videos actually say
---

Research a topic on YouTube.

Ask me for the query if I have not given it, and for the window if recency matters.

Then:

1. Call `hasdata_youtube_search_getYoutubeSearchResults` with `q`. Put any recency window into the `date` filter rather than planning to filter afterwards, because `publishedDate` comes back as a relative string that cannot be resolved to a date. Add `filters__: ["subtitles"]` when the task depends on reading transcripts.
2. Report `videoResults` as the ranking and list `inlineShortsResults` and `playlistResults` separately. Say plainly if `adsResults` or `sponsoredResults` were present, and never mix them into the organic list.
3. For each video give the title, the channel, `length`, `publishedDate` and views, sorting on `views`, which is already the number in this payload. `viewsOriginal` is the printed string and is for display only.
4. Read `chapters` where the search rows carry it. That is the video's outline for free, and it is usually enough to decide which ones are worth opening.
5. Open the two or three that matter with `hasdata_youtube_video_getYoutubeVideo`, and report `lengthSeconds`, `keywords`, `extractedLikes`, the channel's subscriber count and what `description.links` points at. Here `views` is the string and `extractedViews` is the number, the reverse of the search payload.
6. Check `captions` before asking for a transcript. Then call `hasdata_youtube_transcript_getYoutubeTranscript`, confirm a `transcript` key actually came back, and summarise what the video covers, citing `startTimeText` for anything you quote.
7. Look at which entry in `availableTranscripts` has `selected` set, and say when the track you read is `asr`, because an automatic transcript gets names and numbers wrong and a quote from it is not verbatim.

Report what the videos say, not what the titles promise. A title is a claim about the content and the transcript is the content.
