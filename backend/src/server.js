import 'dotenv/config';import app from './app.js';import {connectDatabase} from './config/database.js';
const port=Number(process.env.PORT)||5000;
if(!process.env.JWT_SECRET||process.env.JWT_SECRET.length<32){console.error('JWT_SECRET must be set to a unique secret of at least 32 characters in backend/.env');process.exit(1)}
try{await connectDatabase();app.listen(port,'0.0.0.0',()=>console.log(`API listening on http://localhost:${port}`))}catch(error){console.error('Backend startup failed:',error.message);process.exit(1)}
