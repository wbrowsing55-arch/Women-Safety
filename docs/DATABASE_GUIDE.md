# MongoDB Atlas collections
- `users`: email, password hash, role.
- `communityinterests`: unique user reference; this is the real community count.
- `comments`: user, message, moderation status.
- `suggestions`: user, message, review status.
- `scratchcards`: category, message, enabled state, order.
- `sitesettings`: community milestone target.

Use a least-privilege Atlas database user and allow only the network access needed for development/deployment.
