# ---------- Build Stage ----------
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json yarn.lock ./

# Install dependencies with Yarn
RUN yarn install --frozen-lockfile

# Copy the rest of the source code
COPY . .

# Build the app
RUN yarn build

# ---------- Serve Stage ----------
FROM nginx:alpine

# Remove default html and config
RUN rm -rf /usr/share/nginx/html/*
RUN rm /etc/nginx/conf.d/default.conf

# Copy build output and custom nginx config
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]
