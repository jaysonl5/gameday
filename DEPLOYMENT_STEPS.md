# Production Deployment Steps for EC2

## Initial Setup (One Time Only)

If this is your first deployment, ensure you have:
- [ ] Ruby 3.2.2 installed via rbenv
- [ ] Node.js and Yarn installed
- [ ] PostgreSQL installed and running
- [ ] Nginx configured with Unix socket
- [ ] Environment variables set (see below)

## Deployment Process

### 1. Pull Latest Code

```bash
cd /home/ubuntu/gameday
git pull origin main
```

### 2. Install Dependencies

```bash
# Install Ruby gems
bundle install

# Install JavaScript dependencies
yarn install
```

### 3. Database Migrations

```bash
RAILS_ENV=production bin/rails db:migrate
```

### 4. Build Frontend Assets

```bash
# Build JavaScript with esbuild
yarn build

# This creates:
# - app/assets/builds/application.js
# - app/assets/builds/application.css
```

### 5. Precompile Assets

```bash
RAILS_ENV=production bin/rails assets:precompile
```

**What this does:**
- Copies files from `app/assets/builds/` to `public/assets/`
- Adds digest hashes to filenames (e.g., `application-abc123.js`)
- Creates manifest file mapping logical names to digested names
- Copies images from `app/assets/images/` to `public/assets/images/`
- Rails asset helpers (`javascript_include_tag`, `stylesheet_link_tag`) use this manifest

### 6. Restart Puma

```bash
# If using systemd service
sudo systemctl restart gameday

# OR if using start-puma.sh directly
pkill -f puma
./start-puma.sh
```

### 7. Verify Deployment

```bash
# Check Puma is running
ps aux | grep puma

# Check Unix socket exists
ls -la /home/ubuntu/gameday/tmp/sockets/puma.sock

# Check Puma logs
tail -f /home/ubuntu/gameday/log/puma.stdout.log

# Check nginx can connect
sudo nginx -t
sudo systemctl restart nginx

# Check application logs
tail -f /home/ubuntu/gameday/log/production.log
```

## Environment Variables (Production)

Ensure these are set in your environment (via `.env.production`, systemd service file, or shell profile):

```bash
RAILS_ENV=production
RAILS_SERVE_STATIC_FILES=true  # Optional, Rails now serves static files by default
DATABASE_URL=postgresql://user:password@localhost/gameday_production
SECRET_KEY_BASE=<generate with: rails secret>

# Google OAuth
GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=GOCSPX-your-secret
GOOGLE_HD=yourdomain.com

# Encryption
ENCRYPTION_KEY=<generate with: rails secret>
```

## Troubleshooting

### Assets Not Loading (404 on CSS/JS)

1. **Check if assets were compiled:**
   ```bash
   ls -la public/assets/application*.{js,css}
   ```
   Should see digested filenames like `application-abc123.js`

2. **Check manifest exists:**
   ```bash
   ls -la public/assets/.sprockets-manifest*.json
   ```

3. **Verify Rails is serving static files:**
   ```bash
   # Check production.rb or set environment variable
   export RAILS_SERVE_STATIC_FILES=true
   ```

4. **Re-run asset pipeline:**
   ```bash
   yarn build
   RAILS_ENV=production bin/rails assets:precompile
   sudo systemctl restart gameday
   ```

### Nginx 502 Bad Gateway

1. **Check Puma is running:**
   ```bash
   ps aux | grep puma
   ```

2. **Check Unix socket exists:**
   ```bash
   ls -la /home/ubuntu/gameday/tmp/sockets/puma.sock
   ```

3. **Check nginx configuration:**
   ```bash
   sudo nginx -t
   cat /etc/nginx/sites-enabled/gameday
   ```

4. **Check Puma logs:**
   ```bash
   tail -f /home/ubuntu/gameday/log/puma.stderr.log
   ```

### Database Connection Errors

1. **Verify PostgreSQL is running:**
   ```bash
   sudo systemctl status postgresql
   ```

2. **Check DATABASE_URL is set:**
   ```bash
   echo $DATABASE_URL
   ```

3. **Test database connection:**
   ```bash
   RAILS_ENV=production bin/rails db:migrate:status
   ```

## Quick Deployment Command

For routine deployments after initial setup:

```bash
cd /home/ubuntu/gameday && \
git pull origin main && \
bundle install && \
yarn install && \
yarn build && \
RAILS_ENV=production bin/rails db:migrate && \
RAILS_ENV=production bin/rails assets:precompile && \
sudo systemctl restart gameday && \
echo "✓ Deployment complete!"
```

## Rollback

If deployment fails:

```bash
# Rollback to previous git commit
git reset --hard HEAD~1

# Restart services
sudo systemctl restart gameday
```

## Asset Pipeline Architecture

### Development Flow:
```
esbuild → app/assets/builds/*.{js,css}
         ↓
    Rails dev server serves from builds/ directory
```

### Production Flow:
```
esbuild → app/assets/builds/*.{js,css}
         ↓
    rails assets:precompile
         ↓
    public/assets/application-[digest].{js,css}
         ↓
    Rails serves via Puma (or nginx serves static files)
```

### Asset Tag Helpers:
- `<%= stylesheet_link_tag "application" %>` → `/assets/application-abc123.css`
- `<%= javascript_include_tag "application" %>` → `/assets/application-xyz789.js`

The helpers automatically look up the digested filename from the manifest.

## Post-Deployment Checklist

- [ ] Application loads without errors
- [ ] CSS styles are applied correctly
- [ ] JavaScript is working (React app renders)
- [ ] Images (logo) are visible
- [ ] Login page works
- [ ] Main dashboard loads
- [ ] Check browser console for errors
- [ ] Check production.log for errors
