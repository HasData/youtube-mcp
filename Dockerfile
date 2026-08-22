# Runs the YouTube MCP server as a local stdio process by proxying to HasData's
# hosted endpoint. Provide HASDATA_API_KEY at runtime. Used for Glama releases.
FROM node:22-alpine
WORKDIR /app
COPY package.json index.mjs ./
RUN npm install --omit=dev --no-audit --no-fund
ENTRYPOINT ["node", "index.mjs"]
