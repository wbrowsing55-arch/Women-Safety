# THE SELF-GOVERNED GIRL

A mobile-first React + Vite frontend and Express + MongoDB Atlas backend.

## Requirements
- Node.js 20+ recommended and npm
- MongoDB Atlas database and connection string

## Setup
1. Fill `backend/.env` using `backend/.env.example`.
2. Fill `frontend/.env` using `frontend/.env.example`.
3. From the project root run `npm run install:all`.
4. Run `npm run seed:scratch` once to insert the initial scratch messages.
5. Run `npm run create:admin` once to create the admin account using the values in `backend/.env`.
6. Run `npm run dev` to start both apps.

Frontend: http://localhost:5173
Backend health: http://localhost:5000/api/health

## Security notes
- Never commit `.env` files or publish MongoDB credentials/JWT secrets.
- Change the temporary admin password before production.
- Use HTTPS and configure a strong unique JWT secret for deployment.
- The Know Yourself assessment runs in the browser; answers are not saved to the server.
- Public learning content is source-controlled in `frontend/src/content/`. Changes to that content require a frontend rebuild/redeploy after production deployment. Scratch-card messages are stored in MongoDB and can be changed through the admin UI without rebuilding.

## Important content note
The content files contain the approved copy available in the current project specification. If a previously approved long-form explanation or answer-specific feedback is not represented in the source material available to the generator, add the original wording to the clearly named content file; the UI renders content from those files and does not rewrite it.
