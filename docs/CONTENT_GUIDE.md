# Content editing
Edit static public copy in `frontend/src/content/`. During development Vite refreshes the site; after deployment rebuild and redeploy the frontend. Scratch-card messages are stored in MongoDB Atlas and managed in Admin Panel → Scratch Manager, so those changes do not require a frontend rebuild. Assessment responses stay in browser state and are not stored remotely.
