# ADD: Growtopia Guild Website

A single-page React + Vite site. No backend, no database, no environment variables.

## 1. Add your mascot
Save the Water Asteroid image as **`public/mascot.png`** (exact name, lowercase).
Until then a placeholder drawing is shown. If your file is a different type (e.g. `.webp`), change `MASCOT_IMAGE` in `src/config.js`.

## 2. Edit your content
Open **`src/config.js`**. It holds the Discord invite link, guild name, world, rules, rewards and all main text.
Replace `YOUR_DISCORD_INVITE_LINK` with your real invite (starting with `https://`). Every Discord button updates automatically.
Colors are the variables at the top of `src/styles.css`.

## 3. Run locally
Install Node.js 18+ first, then:
```
npm install
npm run dev
```
Open the address it prints (usually http://localhost:5173).
To test the production build: `npm run build` then `npm run preview`.

## 4. Deploy free on Render via GitHub
1. Create a GitHub repository and upload this whole folder (not `node_modules` or `dist`; `.gitignore` handles that).
2. Go to https://render.com, sign in with GitHub.
3. Click **New +** > **Static Site** and choose your repository.
4. Set:
   - **Build Command:** `npm install && npm run build`
   - **Publish Directory:** `dist`
5. Click **Create Static Site**. When it finishes, Render gives you a public URL.
6. To update later: edit files, commit and push to GitHub. Render redeploys automatically.

---

## Option B: Render Blueprint (one-click from `render.yaml`)
This repo includes a `render.yaml` Blueprint. On Render choose **New +** > **Blueprint**, pick your GitHub repo, and click **Apply**. It creates the static site with the right build command and publish folder automatically.

## Option C: Your own VPS (Ubuntu/Debian + nginx)
1. Point your domain's **A record** to the VPS IP address.
2. SSH into the VPS, then:
   ```
   git clone https://github.com/YOUR-USER/YOUR-REPO.git
   cd YOUR-REPO
   sudo bash deploy/setup-vps.sh your-domain.com --https
   ```
   (Leave off `--https` to skip the free Let's Encrypt certificate. Add it once the domain's DNS has propagated.)
3. To update after you push changes to GitHub: `cd YOUR-REPO && sudo bash deploy/setup-vps.sh your-domain.com`

Files: `deploy/setup-vps.sh` (installer/updater) and `deploy/nginx.conf` (web server config). The site is only static files, so nothing runs on the VPS besides nginx.
