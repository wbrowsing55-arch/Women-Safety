# Project structure
- `frontend/src/pages` is reserved for splitting page components as the application grows; the current integrated app is in `frontend/src/App.jsx`.
- `frontend/src/content` stores static public copy and assessment content.
- `backend/src/models` defines MongoDB collections.
- `backend/src/controllers` contains API behaviour.
- `backend/src/routes` maps API paths.
- `backend/src/middleware` protects authenticated/admin endpoints.
