#!/data/data/com.termux/files/usr/bin/bash
# The Self-Governed Girl — complete project generator for Termux/Linux/macOS
# Run from the existing "Women Safety" project folder. It preserves existing files by default.
set -eu

ROOT="$(pwd)"
if [ "$(basename "$ROOT")" != "Women Safety" ]; then
  echo "Please run this script from your existing 'Women Safety' project folder."
  echo "Current folder: $ROOT"
  exit 1
fi

if [ -e frontend/src/App.jsx ] || [ -e backend/src/server.js ]; then
  echo "Some project files already exist. This generator will not overwrite existing files."
  echo "To generate into a clean folder, back up your current project and run the script there."
  exit 1
fi

command -v node >/dev/null 2>&1 || { echo "Node.js is required. In Termux run: pkg install nodejs-lts"; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "npm is required (normally installed with Node.js)."; exit 1; }

python3 - <<'PY'
from pathlib import Path
import json
root = Path.cwd()
files = {}

def add(path, content): files[path] = content.strip() + "\n"

add('.gitignore', r'''
node_modules/
.env
.env.*
!.env.example
dist/
coverage/
.DS_Store
*.log
''')
add('README.md', r'''
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
''')
add('package.json', r'''
{
  "name": "self-governed-girl",
  "private": true,
  "version": "1.0.0",
  "scripts": {
    "install:all": "npm --prefix frontend install && npm --prefix backend install",
    "dev": "concurrently -k -n API,WEB -c blue,green \"npm --prefix backend run dev\" \"npm --prefix frontend run dev -- --host 0.0.0.0\"",
    "seed:scratch": "npm --prefix backend run seed:scratch",
    "create:admin": "npm --prefix backend run create:admin",
    "build": "npm --prefix frontend run build"
  },
  "devDependencies": {"concurrently": "^9.1.2"}
}
''')
add('backend/.env.example', r'''
PORT=5000
NODE_ENV=development
MONGODB_URI=mongodb+srv://YOUR_DB_USER:YOUR_DB_PASSWORD@YOUR_CLUSTER.mongodb.net/self_governed_girl?retryWrites=true&w=majority
JWT_SECRET=REPLACE_WITH_A_LONG_RANDOM_SECRET_AT_LEAST_32_CHARACTERS
CLIENT_URL=http://localhost:5173
ADMIN_EMAIL=admin@gmail.com
ADMIN_INITIAL_PASSWORD=CHANGE_THIS_TEMPORARY_PASSWORD
COMMUNITY_TARGET=21
''')
add('frontend/.env.example', r'''
VITE_API_URL=http://localhost:5000/api
''')
add('frontend/package.json', r'''
{
  "name":"self-governed-girl-frontend","private":true,"version":"1.0.0","type":"module",
  "scripts":{"dev":"vite","build":"vite build","preview":"vite preview --host 0.0.0.0"},
  "dependencies":{"@vitejs/plugin-react":"latest","vite":"latest","react":"latest","react-dom":"latest","react-router-dom":"latest"},
  "devDependencies":{}
}
''')
add('frontend/index.html', r'''
<!doctype html><html lang="en"><head><meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/><meta name="theme-color" content="#080b18"/><meta name="description" content="Know yourself. Understand reality. Protect your dignity. Govern your life."/><title>The Self-Governed Girl</title></head><body><div id="root"></div><script type="module" src="/src/main.jsx"></script></body></html>
''')
add('frontend/vite.config.js', r'''
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
export default defineConfig({ plugins: [react()], server: { host: '0.0.0.0' } });
''')
add('backend/package.json', r'''
{
  "name":"self-governed-girl-backend","private":true,"version":"1.0.0","type":"module",
  "scripts":{"dev":"nodemon src/server.js","start":"node src/server.js","seed:scratch":"node src/scripts/seedScratchCards.js","create:admin":"node src/scripts/createAdmin.js"},
  "dependencies":{"bcryptjs":"^2.4.3","cors":"^2.8.5","dotenv":"^16.4.7","express":"^4.21.2","express-rate-limit":"^7.5.0","helmet":"^8.0.0","jsonwebtoken":"^9.0.2","mongoose":"^8.9.5"},
  "devDependencies":{"nodemon":"^3.1.9"}
}
''')

add('frontend/src/content/homeContent.js', r'''
export const homeContent = {
  eyebrow: 'A GUIDE TO UNDERSTANDING LIFE',
  title: 'THE SELF-GOVERNED GIRL',
  tagline: 'Know Yourself. Understand Reality. Protect Your Dignity. Govern Your Life.',
  introduction: "A girl should not be taught merely how to behave when everything is good. She should be taught how to think when she is confused, recognise reality when emotions cloud her judgment, protect herself when she is vulnerable, and make wise decisions when the world pressures her.",
  purpose: 'The goal is not to control a girl\'s life. It is to help her become capable of governing herself.',
  pillars: [
    { number: '01', title: 'Awareness', text: 'Be aware enough to recognise reality.' },
    { number: '02', title: 'Wisdom', text: 'Be wise enough to understand your choices.' },
    { number: '03', title: 'Courage', text: 'Be brave enough to protect your boundaries.' },
    { number: '04', title: 'Intelligence', text: 'Be intelligent enough to find a way forward.' },
    { number: '05', title: 'Responsibility', text: 'Be responsible enough to govern yourself.' }
  ],
  rememberTitle: 'Remember this above everything',
  remember: "Don't let the world decide your worth. Don't let emotions blind your judgment. Don't let fear silence your needs. Don't let pressure make your decisions. And don't let the desire for freedom make you forget responsibility. Know yourself. Read the situation. Protect your dignity. Choose wisely. Govern yourself.",
  essence: 'A truly empowered girl understands reality without becoming fearful, loves without losing herself, stands up for herself without losing her values, adapts to circumstances without abandoning her principles, and uses her freedom with wisdom and responsibility.',
  transition: 'Understanding yourself is powerful. Learning from one another can make that journey richer.'
};
''')

add('frontend/src/content/principles.js', r'''
export const principles = [
 {id:1,title:'Self-Awareness',subtitle:'Know Yourself Before the World Defines You',meaning:'Understand your values, feelings, needs, strengths, limits, and patterns before allowing other people to define who you are.',guidance:'Pause and notice what you genuinely think and feel. Separate your own values from expectations, trends, and pressure. Ask what matters to you and why.',takeaway:'Know yourself before you let the world name you.'},
 {id:2,title:'Self-Control',subtitle:"Feel Everything, but Don't Let Every Feeling Control You",meaning:'Emotions are real signals, but they do not have to make every decision for you.',guidance:'Give yourself time to calm down when possible. Name the feeling, understand what triggered it, and choose a response that fits your values and safety.',takeaway:'Feel deeply. Choose deliberately.'},
 {id:3,title:'Self-Boundaries',subtitle:'Know What You Should and Should Not Allow',meaning:'Boundaries describe what you are comfortable with and what you will do when a limit is crossed.',guidance:'You can say no, ask for space, change your mind, or leave a situation. You can be respectful without agreeing to everything.',takeaway:'Kindness does not require abandoning your boundaries.'},
 {id:4,title:'Environmental Awareness',subtitle:'Understand the Place and People Around You',meaning:'Notice the environment, people, available support, exit routes, and practical circumstances without assuming that danger is everywhere.',guidance:'Consider the setting, your comfort, transport, and who you can contact. Clothing never causes or excuses harassment; choose what feels right for you and the situation.',takeaway:'Awareness gives you more options; it never makes you responsible for another person’s misconduct.'},
 {id:5,title:'Emotional Awareness',subtitle:"Don't Make Permanent Decisions During Temporary Emotional States",meaning:'Strong emotions can narrow attention and make immediate relief feel more important than long-term wellbeing.',guidance:'When safe to do so, pause before major decisions. Talk to someone trustworthy, sleep on it, or write down your options. If urgent action is needed for safety, act first.',takeaway:'Let emotions inform you, not decide everything for you.'},
 {id:6,title:'Hormonal Awareness',subtitle:'Understand Your Body Without Becoming Its Prisoner',meaning:'Physical and hormonal changes can influence mood and energy, but they do not define your character or remove your agency.',guidance:'Notice patterns without judging yourself. Rest, seek reliable health advice when needed, and avoid using a body change as a reason to dismiss your feelings.',takeaway:'Understand your body with compassion and clear judgment.'},
 {id:7,title:'Love',subtitle:'Love Someone Without Abandoning Yourself',meaning:'Healthy love includes respect, honesty, consent, freedom, and room for both people to grow.',guidance:'Notice actions over promises. You should be able to keep your friendships, values, boundaries, and voice. Pressure, threats, and control are not proof of love.',takeaway:'Love can include another person without erasing you.'},
 {id:8,title:'Lust and Sexual Desire',subtitle:'Understand Desire Without Letting It Override Your Judgment',meaning:'Desire is a human feeling; it does not cancel consent, comfort, values, or consequences.',guidance:'Make choices freely and without pressure. Consent must be voluntary and can be withdrawn. You never owe anyone access to your body or private information.',takeaway:'Desire is a feeling, not an obligation.'},
 {id:9,title:'Friendship',subtitle:'Choose People Who Respect Your Growth',meaning:'Supportive friends respect your boundaries and can disagree without humiliating or controlling you.',guidance:'Observe how people act when you say no, succeed, make a mistake, or need support. You can care about someone while creating distance from harmful behaviour.',takeaway:'Choose friends who respect the person you are becoming.'},
 {id:10,title:'Social Trends',subtitle:'Be Modern Without Becoming Mindless',meaning:'A trend can be enjoyable without being right for every person or every situation.',guidance:'Ask whether you genuinely like it, whether it fits your needs, and whether you are choosing freely rather than fearing exclusion.',takeaway:'Explore trends; keep your judgment.'},
 {id:11,title:'Social Influence',subtitle:"Don't Confuse Acceptance With Self-Worth",meaning:'Belonging matters, but approval from others is not the measure of your value.',guidance:'Notice when you are changing a choice only to avoid criticism. Seek people who allow honest differences and respect your decisions.',takeaway:'You can belong without pretending to be someone else.'},
 {id:12,title:'Guilt and Emotional Manipulation',subtitle:'Learn the Difference Between Responsibility and Control',meaning:'Healthy accountability addresses real harm; manipulation uses guilt, fear, or obligation to control your choices.',guidance:'Ask what actually happened, what responsibility is yours, and whether the other person respects your right to decide. Seek outside perspective if you feel confused or pressured.',takeaway:'Own your actions without surrendering your judgment.'},
 {id:13,title:'Harassment and Intimidation',subtitle:"Don't Let Fear Convince You That You Have No Options",meaning:'Harassment and intimidation are not your fault. You may have options even when confronting the person directly is unsafe.',guidance:'Prioritise immediate safety. Move toward a safer place, contact trusted people or emergency support, document what is safe to document, and report when appropriate. You do not have to confront someone.',takeaway:'Your safety comes before proving your courage.'},
 {id:14,title:'Silence and Assertiveness',subtitle:'Know When to Speak and How to Act',meaning:'Speaking up can help, but silence, leaving, documenting, or seeking help can also be wise responses depending on risk.',guidance:'Use a clear boundary when safe. If speaking could increase danger, prioritise getting away and finding support.',takeaway:'Assertiveness is choosing an effective response, not always speaking loudly.'},
 {id:15,title:'Intelligence and Strategy',subtitle:'Choose the Response That Protects Your Interests',meaning:'A wise response considers your safety, goals, resources, timing, and likely consequences.',guidance:'Consider several options: clarify, refuse, compromise, document, seek help, report, or leave. Choose the safest realistic option for the circumstances.',takeaway:'You do not have to react instantly to respond intelligently.'},
 {id:16,title:'Authority and Workplace Pressure',subtitle:'Respect Positions Without Surrendering Your Rights',meaning:'A person’s position does not make every demand appropriate or remove your right to dignity and fair treatment.',guidance:'Stay professional where possible, clarify requests, keep records when appropriate, consult trusted colleagues or formal channels, and consider your safety and livelihood.',takeaway:'Respect authority without treating it as unlimited power.'},
 {id:17,title:'Freedom and Responsibility',subtitle:'Understand That Choice Has Consequences',meaning:'Freedom includes the ability to make decisions and the responsibility to consider their effects on yourself and others.',guidance:'Make choices intentionally, understand realistic consequences, and remember that responsible choices do not mean accepting blame for another person’s harmful actions.',takeaway:'Use freedom with thought, not fear.'},
 {id:18,title:'Reality Over Fantasy',subtitle:'See People for Their Actions, Not Just Your Hopes',meaning:'Hope can be meaningful, but repeated actions provide important information about trust and respect.',guidance:'Notice patterns, not only apologies or promises. Give people room to grow while protecting yourself from repeated harm.',takeaway:'Let reality inform your hope.'},
 {id:19,title:'Circumstances and Adaptability',subtitle:'Change Your Strategy Without Losing Your Principles',meaning:'Different situations may require different approaches while your core values remain steady.',guidance:'You may speak in one setting, leave another, seek help in a third, or wait until it is safer. Adapting is not the same as surrendering your values.',takeaway:'Keep your principles; adapt your approach.'},
 {id:20,title:'Self-Respect',subtitle:'Never Make Your Worth Dependent on Someone Else',meaning:'Your worth is not decided by attention, relationship status, popularity, rejection, or another person’s opinion.',guidance:'Treat yourself with dignity, accept feedback without accepting humiliation, and seek relationships where respect is mutual.',takeaway:'Your worth is not up for someone else to grant or remove.'},
 {id:21,title:'Self-Growth and Independence',subtitle:'Build More Choices for Your Future',meaning:'Skills, education, financial awareness, relationships, and self-trust can expand your future options.',guidance:'Build skills steadily, ask questions, learn practical life tasks, and seek support when you need it. Independence can grow step by step.',takeaway:'Build a future with more choices.'},
 {id:22,title:'Accountability',subtitle:'Be Honest About Your Own Actions',meaning:'Self-governance includes recognising your mistakes, repairing harm where possible, and learning without defining yourself by one failure.',guidance:'Separate accountability from shame. Acknowledge what happened, apologise when appropriate, make amends, and change the pattern.',takeaway:'Be honest enough to learn and brave enough to improve.'}
];
''')

add('frontend/src/content/fiveStepRule.js', r'''
export const fiveSteps = [
 {number:'01',title:'PAUSE',text:'Don’t react automatically; recognise emotions and take time if possible.',detail:'Give yourself a moment to notice what you feel and avoid acting only from the first impulse. If you are in immediate danger, prioritise safety rather than waiting.'},
 {number:'02',title:'OBSERVE',text:'Understand people, environment, circumstances, power dynamics, and risks.',detail:'Look at what is happening, where you are, who is present, what support is available, and whether the situation is changing.'},
 {number:'03',title:'EVALUATE',text:'Ask what’s happening, what boundaries and choices you have, and the likely consequences.',detail:'Consider your options and their practical effects. You do not need a perfect answer; look for the safest realistic next step.'},
 {number:'04',title:'ACT',text:'Speak, refuse, compromise, seek help, document, report, leave, or choose another appropriate action.',detail:'Choose the response that fits your circumstances. In immediate danger, move to safety and contact trusted or emergency support when possible.'},
 {number:'05',title:'LEARN',text:'Reflect on what happened, what worked, what to improve, and what support or preparation may help.',detail:'Learning is not blaming yourself. Notice what you can carry forward and remember that responsibility for another person’s misconduct belongs to them.'}
];
export const fiveStepClosing = 'Pause before reacting. Observe before judging. Evaluate before deciding. Act with wisdom. Learn without losing yourself.';
''')

add('frontend/src/content/realLifeSituations.js', r'''
export const situations = [
 {id:'relationships',title:'Relationships',intro:'Respect, trust, consent, and room to remain yourself.',signs:['Your boundaries are respected, including when you change your mind.','You can disagree without threats or humiliation.','Pressure, monitoring, isolation, or fear may signal an unhealthy dynamic.'],options:['State a boundary if it feels safe.','Talk with a trusted person and consider your options.','Create distance or seek support if the behaviour continues or risk increases.'],lesson:'Healthy care does not require you to abandon your safety, voice, or identity.'},
 {id:'friendship',title:'Friendship',intro:'Friendship should leave room for honesty, difference, and growth.',signs:['A friend accepts a no without punishment.','Jokes repeatedly target your vulnerabilities.','You feel pressured to prove loyalty by doing something uncomfortable.'],options:['Explain your boundary if safe.','Seek perspective from someone you trust.','Take space if the pattern continues.'],lesson:'You can care about a friend and still choose distance from harmful behaviour.'},
 {id:'harassment',title:'Harassment',intro:'Harassment is not your fault; your safety comes first.',signs:['Unwanted repeated contact, intimidation, threats, or boundary violations.','Someone follows you or tries to isolate you.','You feel that direct confrontation could increase risk.'],options:['Move toward a safer or more public place if possible.','Contact trusted people or local emergency support.','Document or report when safe and appropriate; do not confront if unsafe.'],lesson:'You do not need to prove courage by facing danger alone.'},
 {id:'workplace',title:'Workplace Pressure',intro:'Professionalism does not mean accepting every demand.',signs:['A request is unclear, inappropriate, or outside agreed expectations.','You are pressured to keep concerning behaviour secret.','A person uses their position to threaten or humiliate you.'],options:['Ask for clarification in a professional way.','Keep appropriate records and seek trusted advice.','Use relevant workplace reporting channels when appropriate.'],lesson:'Respect positions without treating authority as unlimited power.'},
 {id:'family',title:'Family Expectations',intro:'You can respect family while thinking carefully about your own needs.',signs:['A discussion leaves no room for questions.','Guilt or threats are used to force a choice.','You are unsure whether disagreement is safe.'],options:['Choose a calm time to discuss the issue if safe.','Ask a trusted person to help you think through options.','Prioritise safety and seek outside support if coercion or threats occur.'],lesson:'Respect and self-respect can exist together; the safest response depends on circumstances.'},
 {id:'digital',title:'Digital Safety',intro:'Your private information, images, and accounts deserve protection.',signs:['Someone asks for passwords, intimate content, or private information under pressure.','A person threatens to publish messages or images.','An unknown link or account requests sensitive details.'],options:['Do not send more information under pressure.','Save relevant evidence if safe, block/report where appropriate, and secure accounts.','Contact trusted support or relevant authorities if threats continue.'],lesson:'You do not owe anyone private content, passwords, or continued access to you.'},
 {id:'comfort',title:'Clothing, Environment & Comfort',intro:'Your comfort matters, and clothing never causes or excuses harassment.',signs:['You feel uncomfortable with the setting or people around you.','You have not checked practical details such as transport or exit options.','You feel pressured to dress or act against your own comfort.'],options:['Choose clothing that feels right for you and the setting.','Review transport, exits, and who you can contact.','Change plans or leave if you want to; seek support if someone behaves inappropriately.'],lesson:'Prepare for your comfort and choices without taking responsibility for other people’s misconduct.'},
 {id:'travel',title:'Public Safety & Travel',intro:'Practical planning can give you options without requiring constant fear.',signs:['Your route or transport plan is unclear.','Your phone battery or contact options may be limited.','A person or place makes you feel unsafe.'],options:['Check your route and transport options.','Tell a trusted person your plan when useful.','Move to a safer location and contact help if risk appears.'],lesson:'Awareness is preparation, not a promise that you can control every outcome.'}
];
''')

add('frontend/src/content/letters.js', r'''
export const letters = [
 {id:'know-your-worth',title:'A Letter About Your Worth',opening:'My girl,',body:'Your worth is not measured by who chooses you, who notices you, who stays, or who leaves. You are allowed to learn, change your mind, ask questions, and begin again. Listen to advice, but do not hand another person the power to define your entire life. Look at actions, protect your boundaries, and give yourself the same patience you offer someone you love.',takeaway:'You can care deeply without losing yourself.',related:[1,3,7,20]},
 {id:'when-confused',title:'When You Do Not Know What to Do',opening:'My girl,',body:'When emotions are loud and the next step is unclear, you do not have to solve your whole life in one moment. Pause if it is safe. Notice what is happening. Consider your choices and ask someone trustworthy for perspective. Sometimes courage means speaking. Sometimes it means leaving, waiting, documenting, or asking for help. Choose the safest realistic next step.',takeaway:'You do not need a perfect answer to take a wise next step.',related:[2,5,14,15]},
 {id:'boundaries',title:'A Letter About Boundaries',opening:'My girl,',body:'You can be polite and still say no. You can forgive and still choose distance. You can love someone and still expect respect. A boundary is not a punishment; it is a way of being honest about what you can accept and what you will do to protect your wellbeing. You are not required to make everyone happy at the cost of yourself.',takeaway:'Kindness and boundaries can stand together.',related:[3,7,9,12]},
 {id:'asking-help',title:'You Are Allowed to Ask for Help',opening:'My girl,',body:'You do not have to carry every difficult moment alone. Asking for help is not proof that you failed. Choose people who listen, respect your choices, and take your concerns seriously. If one person cannot help, try another trusted person or an appropriate support service. When danger is immediate, focus on reaching safety.',takeaway:'Courage can look like reaching out.',related:[13,14,15,21]}
];
''')

add('frontend/src/content/suggestionsContent.js', r'''
export const suggestionsContent = {
 title:'Help Shape What Comes Next',
 intro:'Suggest a topic, ask a question, recommend a real-life situation, or share an idea that could make this guide more useful.',
 prompt:'What would you like us to explore next?',
 note:'Sign in to submit a suggestion. Suggestions are reviewed before they are used.'
};
''')

add('frontend/src/content/knowYourselfQuestions.js', r'''
// Assessment answers are kept in local component state only; no answer is sent to the server.
// Each option has a distinct score and feedback. The score reflects reported preparation/habits,
// not personal worth, character, or whether another person's harmful behaviour is the user's fault.
export const assessmentCategories = [
 {id:'environment',title:'Environmental Awareness'},
 {id:'emotions',title:'Emotional Awareness'},
 {id:'boundaries',title:'Boundaries and Personal Safety'},
 {id:'influence',title:'Love, Friendship and Influence'},
 {id:'preparedness',title:'Awareness and Preparedness'}
];
const q = (id,category,question,options) => ({id,category,question,options});
const opt = (label,text,score,feedback) => ({label,text,score,feedback});
export const assessmentQuestions = [
q(1,'environment','Are you comfortable with what you\'re wearing in the environment you\'re entering?',[opt('A','Yes, I feel comfortable and have chosen for myself.',4,'You are checking your own comfort and making an intentional choice. Remember: clothing never causes or excuses harassment.'),opt('B','Mostly, though I may reconsider if the setting changes.',3,'You are aware of your comfort and willing to adapt. Keep your choice yours; you are not responsible for other people’s behaviour.'),opt('C','I am unsure and need a moment to think.',2,'Taking a moment to check in with yourself is useful. Ask what would help you feel comfortable, without blaming yourself for anyone else’s actions.'),opt('D','I feel pressured by what other people expect me to wear.',1,'This may be a chance to reflect on whose expectations are shaping your choice. Your comfort matters, and you can seek support if pressure feels unsafe.')]),
q(2,'environment','Do you feel comfortable with the people around you?',[opt('A','Yes, and I still stay aware of my surroundings.',4,'You can feel comfortable while remaining aware of your options.'),opt('B','I feel mostly comfortable but keep some distance until I know people.',3,'You are allowing trust to develop over time. Notice whether people respect boundaries.'),opt('C','I am unsure and want to observe a little longer.',2,'Observing before deciding how much to engage can be sensible.'),opt('D','Someone is making me uncomfortable or pressuring me.',1,'Your discomfort deserves attention. If you feel unsafe, move toward safety and contact someone you trust; you do not have to confront the person.')]),
q(3,'environment','Have you planned how you\'ll get home?',[opt('A','Yes, I know my transport plan and alternatives.',4,'Planning a route and backup options gives you more choices.'),opt('B','I have a plan, but I have not checked alternatives.',3,'You have a starting plan. Consider a backup option in case circumstances change.'),opt('C','Not yet, but I can check before I go.',2,'Taking a moment to plan before leaving can make the trip easier to manage.'),opt('D','No, and I may depend on someone I do not fully trust.',1,'Consider a safer alternative or contact someone you trust before proceeding if possible. Your safety matters more than avoiding awkwardness.')]),
q(4,'environment','Are you comfortable with the place you\'re visiting?',[opt('A','Yes, and I know how to leave or get help if needed.',4,'You have considered both comfort and practical options.'),opt('B','Mostly; I know a little about the place.',3,'You have some awareness. Checking transport and exits may help you feel more prepared.'),opt('C','I am unfamiliar with it and need more information.',2,'It is reasonable to learn more or ask someone trustworthy before deciding.'),opt('D','I feel unsafe or pressured to go there.',1,'You can reconsider or decline if you can do so safely. If you are already in danger, focus on getting to safety and contacting help.')]),
q(5,'emotions','Are you making this decision because you want to, or because someone expects you to?',[opt('A','I understand what I want and can explain why.',4,'You are checking your own reasons rather than following pressure automatically.'),opt('B','I want it, but other people’s opinions affect me too.',3,'It is normal to consider others. Check that your final choice still feels freely made.'),opt('C','I am not sure what I want yet.',2,'You are allowed to take time, ask questions, and decide when you feel clearer.'),opt('D','I am choosing mainly to avoid someone’s anger or disappointment.',1,'Pressure can make it hard to choose freely. If safe, pause and speak with someone trustworthy; if refusal could put you at risk, prioritise safety and support.')]),
q(6,'emotions','Are your emotions making it difficult to think clearly?',[opt('A','I can recognise my feelings and still consider my options.',4,'You are noticing emotions without assuming they must decide for you.'),opt('B','I feel strongly, but I can usually pause.',3,'You have a useful habit to build on: take a pause when circumstances allow.'),opt('C','I am overwhelmed and need time or support.',2,'Recognising overwhelm is a strength. Consider delaying non-urgent decisions and talking with someone you trust.'),opt('D','I feel unable to think clearly and need immediate support.',1,'Please focus on what you need right now. Reach out to a trusted person; if you are in immediate danger, move toward safety and contact local emergency support.')]),
q(7,'emotions','Are you saying yes because you want to, or because you fear disappointing someone?',[opt('A','I can say yes or no honestly.',4,'You are checking consent and your own willingness.'),opt('B','I sometimes worry about disappointing people but can decide.',3,'Noticing the pressure is useful. Practise giving yourself time before answering.'),opt('C','I often agree before checking what I want.',2,'You can practise saying, “Let me think about it,” when that is safe and appropriate.'),opt('D','I feel I cannot refuse without consequences.',1,'That pressure matters. Seek trusted support and consider the safest response; you do not have to confront someone if doing so is unsafe.')]),
q(8,'emotions','Are you feeling lonely, guilty, or afraid of losing someone?',[opt('A','I can recognise those feelings without letting them decide everything.',4,'You are separating feelings from the full decision.'),opt('B','I feel them, but I can talk it through.',3,'Talking with a trusted, non-pressuring person may help you see more options.'),opt('C','Those feelings are making the choice difficult.',2,'You do not need to rush. Consider what you would choose if fear and guilt were not pressuring you.'),opt('D','I am afraid someone will punish, threaten, or abandon me if I do not agree.',1,'Threats and coercion deserve support. If possible, contact someone trustworthy and prioritise safety rather than handling it alone.')]),
q(9,'boundaries','Are you comfortable with the way someone is treating you?',[opt('A','Yes, I feel respected and can speak honestly.',4,'Respect includes being able to communicate and disagree safely.'),opt('B','Mostly, though some things need a conversation.',3,'You have noticed an area to discuss if it feels safe.'),opt('C','I am unsure whether the behaviour is okay.',2,'You can seek an outside perspective from someone you trust and compare behaviour with your boundaries.'),opt('D','No, I feel disrespected, threatened, or controlled.',1,'You deserve support. If direct confrontation could increase risk, do not force it; consider distance, trusted help, or emergency support if danger is immediate.')]),
q(10,'boundaries','Are you staying silent because you choose to, or because you\'re afraid?',[opt('A','I choose when to speak and when another response is safer.',4,'You understand that silence, speaking, leaving, or seeking help can each be strategic depending on risk.'),opt('B','I sometimes stay quiet, then speak when I feel ready.',3,'Choosing timing can be helpful when it is safe to wait.'),opt('C','I find it hard to know whether speaking is safe.',2,'Consider the context and ask a trusted person for perspective when possible.'),opt('D','I am afraid speaking could put me in danger.',1,'You do not have to speak directly to prove strength. Prioritise safety, seek support, and choose a safer way to respond.')]),
q(11,'boundaries','Is someone asking you to do something that makes you uncomfortable?',[opt('A','No, or I can freely decline requests.',4,'Having room to choose freely is important.'),opt('B','A request feels uncomfortable, but I can ask questions.',3,'Clarifying the request can help if doing so feels safe.'),opt('C','I am unsure how to respond.',2,'You can pause and consider options, including asking for advice or saying you need time.'),opt('D','I feel pressured, threatened, or unable to refuse.',1,'Pressure or threats deserve attention. Focus on safety and contact trusted support; you do not owe compliance to avoid blame.')]),
q(12,'boundaries','Are you maintaining your boundaries while respecting others?',[opt('A','Yes, I try to be clear and respectful.',4,'You are aiming for mutual respect: your boundaries matter, and so do other people’s.'),opt('B','Usually, though I sometimes struggle to say what I need.',3,'Practise clear, simple wording and remember you can ask for time.'),opt('C','I often ignore my limits to avoid conflict.',2,'Notice the cost of ignoring your limits and identify one small boundary you can practise safely.'),opt('D','I expect others to respect my boundaries, but I do not always respect theirs.',1,'Self-governance includes mutual respect. Consider how to honour other people’s no while expressing your own needs.')]),
q(13,'influence','Do you feel safe and respected in your relationships?',[opt('A','Yes, and I can raise concerns honestly.',4,'Feeling respected and being able to raise concerns are positive signs.'),opt('B','Mostly, with a few things I want to understand better.',3,'Notice patterns and discuss concerns when it is safe.'),opt('C','I am uncertain about some behaviour.',2,'Compare actions over time and seek a trustworthy outside perspective.'),opt('D','I feel afraid, controlled, or threatened.',1,'Your safety comes first. Consider trusted support and a safety plan; if danger is immediate, move to safety and contact local emergency help.')]),
q(14,'influence','Are you following a trend because you genuinely like it or because everyone else is doing it?',[opt('A','I choose based on my own interest and judgment.',4,'You are making room for individuality and considered choice.'),opt('B','I like it, though popularity influenced me a little.',3,'Influence is normal; check whether you would still choose it freely.'),opt('C','I am unsure whether I genuinely like it.',2,'Give yourself time to decide without needing immediate approval.'),opt('D','I am doing it mainly because I fear exclusion or criticism.',1,'You can belong without agreeing to everything. Ask what feels right for you and whether the pressure is worth it.')]),
q(15,'influence','Does someone\'s attention make you feel valued, or pressured to give something in return?',[opt('A','I can enjoy attention without feeling I owe anything.',4,'Attention does not create an obligation; your boundaries remain yours.'),opt('B','I enjoy it but check that expectations are mutual.',3,'Checking expectations and consent is a thoughtful habit.'),opt('C','I feel confused about what the person expects.',2,'You can ask for clarity or take space before deciding, if safe.'),opt('D','I feel I must give something to keep their attention.',1,'You do not owe affection, access, images, or agreement in exchange for attention. Seek support if pressure continues.')]),
q(16,'influence','Are you compromising willingly or sacrificing something important out of fear?',[opt('A','I understand what I am choosing and feel free to decide.',4,'A willing compromise leaves room for your agency and values.'),opt('B','I am balancing my needs with someone else’s.',3,'Balance can be healthy when both people’s needs and limits count.'),opt('C','I am not sure whether the compromise is okay for me.',2,'Take time to identify what matters to you and what you may regret giving up.'),opt('D','I am sacrificing something important because I fear the consequences of refusing.',1,'Fear-driven pressure deserves careful attention. Seek trusted support and choose the safest available response.')]),
q(17,'preparedness','Has anything around you made you feel unsafe?',[opt('A','No, I currently feel safe and know how to seek help.',4,'It is useful to know your support options. This answer describes your current situation, not your character.'),opt('B','Something feels uncertain, so I am paying attention.',3,'You are noticing uncertainty. Consider what would help you feel safer.'),opt('C','Yes, I feel uncomfortable and want to move or check in with someone.',2,'Take your discomfort seriously and consider moving to a safer place or contacting someone you trust.'),opt('D','Yes, I may be in immediate danger.',1,'Please prioritise immediate safety now: move away from the danger if possible, approach a safer place or trusted person, and contact local emergency services if needed. Your score does not matter right now.')]),
q(18,'preparedness','Do you have trusted people you can contact when you need help?',[opt('A','Yes, I know who I can contact and how.',4,'Knowing specific support options is a useful preparation habit.'),opt('B','I have someone, but I may need to confirm availability.',3,'Consider keeping more than one trusted contact if possible.'),opt('C','I am unsure who I would contact.',2,'You can gradually identify a trusted person, professional, or appropriate local support service.'),opt('D','I do not currently feel I have anyone safe to contact.',1,'You deserve support. Consider a reputable local support service or professional, and if danger is immediate contact emergency services. This answer is not a personal failing.')]),
q(19,'preparedness','Are you making this choice freely, without pressure or fear?',[opt('A','Yes, I understand my choice and feel free to decide.',4,'You are checking that your choice is genuinely yours.'),opt('B','Mostly, though I am considering other people’s views.',3,'Considering advice can be healthy when the final choice remains voluntary.'),opt('C','I am unsure whether pressure is affecting me.',2,'Pause if possible and identify what you want, what others want, and what consequences concern you.'),opt('D','No, I feel pressured or afraid of what will happen if I refuse.',1,'Pressure can limit choice. Seek trusted support and prioritise safety; you do not need to confront someone if that is unsafe.')]),
q(20,'preparedness','Have you considered your comfort and safety before moving forward?',[opt('A','Yes, I have checked what matters and considered my options.',4,'You are making a deliberate check before acting.'),opt('B','I have considered the main things but may need to check one detail.',3,'A quick final check may help you feel more prepared.'),opt('C','Not yet; I need a little time to think.',2,'If circumstances allow, take that time and consider your options.'),opt('D','I feel rushed or unable to consider my comfort and safety.',1,'You deserve time and choice. If someone is rushing or threatening you, seek support and prioritise immediate safety.')])
];
''')

add('frontend/src/content/lifeCompass.js', r'''
export const compassConnections = [
 {from:'Self-Awareness',to:'Emotional Awareness',why:'Knowing yourself helps you notice what you feel and what influences your decisions.'},
 {from:'Emotional Awareness',to:'Love',why:'Strong feelings can be part of love, while awareness helps you keep your own judgment.'},
 {from:'Love',to:'Guilt and Emotional Manipulation',why:'Care and guilt can become confused when someone uses pressure to control a choice.'},
 {from:'Guilt and Emotional Manipulation',to:'Self-Boundaries',why:'Recognising pressure helps you identify what you can and cannot accept.'},
 {from:'Self-Boundaries',to:'Intelligence and Strategy',why:'Once you know your boundary, you can choose a realistic way to protect it.'},
 {from:'Intelligence and Strategy',to:'Circumstances and Adaptability',why:'A wise plan may change as the situation changes.'},
 {from:'Environmental Awareness',to:'Harassment and Intimidation',why:'Noticing surroundings and options can help you choose a safer next step.'},
 {from:'Authority and Workplace Pressure',to:'Self-Boundaries',why:'Professional respect and personal boundaries can coexist.'},
 {from:'Freedom and Responsibility',to:'Accountability',why:'Self-governance includes considering consequences and owning your own actions.'},
 {from:'Friendship',to:'Social Influence',why:'Friends can influence decisions, so respect and independent judgment matter.'},
 {from:'Five-Step Rule',to:'Real-Life Situations',why:'Pause, observe, evaluate, act, and learn can guide reflection across different situations.'},
 {from:'Know Yourself',to:'Points to Know',why:'Assessment reflections can point to principles worth exploring; they are not a diagnosis or a judgment of character.'}
];
''')

add('frontend/src/content/mothersLetter.js', r'''
export const mothersLetter = `When you don’t know what to do, how to dress for the place and environment, or how to respond to a situation, pause and ask yourself:\n\nIf Mom stood here,\nWhat would I hope she would choose?\nWhat would make me proud?\n\nLet Mom be your mirror,\nLet wisdom guide your way.\nBe the woman your child looks up to,\nAnd dreams of becoming someday.`;
''')

add('frontend/src/content/scratchCardSeed.js', r'''
// Initial seed only. MongoDB is the live source after seeding; admin edits are not overwritten on restart.
export const scratchCardSeed = [
 {category:'Comfort & Environment',message:'Are you comfortable with what you’re wearing in the environment you’re entering?'},
 {category:'Comfort & Environment',message:'Do you feel comfortable with the people around you?'},
 {category:'Comfort & Environment',message:'Have you planned how you’ll get home?'},
 {category:'Comfort & Environment',message:'Are you comfortable with the place you’re visiting?'},
 {category:'Emotions & Decisions',message:'Are you making this decision because you want to, or because someone expects you to?'},
 {category:'Emotions & Decisions',message:'Are your emotions making it difficult to think clearly?'},
 {category:'Emotions & Decisions',message:'Are you saying yes because you want to, or because you fear disappointing someone?'},
 {category:'Emotions & Decisions',message:'Are you feeling lonely, guilty, or afraid of losing someone?'},
 {category:'Boundaries & Personal Safety',message:'Are you comfortable with the way someone is treating you?'},
 {category:'Boundaries & Personal Safety',message:'Are you staying silent because you choose to, or because you’re afraid?'},
 {category:'Boundaries & Personal Safety',message:'Is someone asking you to do something that makes you uncomfortable?'},
 {category:'Boundaries & Personal Safety',message:'Are you maintaining your boundaries while respecting others?'},
 {category:'Love, Friendship & Influence',message:'Do you feel safe and respected in your relationships?'},
 {category:'Love, Friendship & Influence',message:'Are you following a trend because you genuinely like it or because everyone else is doing it?'},
 {category:'Love, Friendship & Influence',message:'Does someone’s attention make you feel valued, or pressured to give something in return?'},
 {category:'Love, Friendship & Influence',message:'Are you compromising willingly or sacrificing something important out of fear?'},
 {category:'Awareness & Preparedness',message:'Has anything around you made you feel unsafe?'},
 {category:'Awareness & Preparedness',message:'Do you have trusted people you can contact when you need help?'},
 {category:'Awareness & Preparedness',message:'Are you making this choice freely, without pressure or fear?'},
 {category:'Awareness & Preparedness',message:'Have you considered your comfort and safety before moving forward?'}
];
''')

add('frontend/src/services/api.js', r'''
const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000/api';
export function getToken(){ return localStorage.getItem('sgg_token'); }
export function setToken(token){ token ? localStorage.setItem('sgg_token',token) : localStorage.removeItem('sgg_token'); }
export async function api(path, options={}) {
 const headers = { 'Content-Type':'application/json', ...(options.headers||{}) };
 const token = getToken(); if(token) headers.Authorization = `Bearer ${token}`;
 const response = await fetch(`${API_URL}${path}`, {...options, headers});
 const data = await response.json().catch(()=>({message:'Unexpected server response'}));
 if(!response.ok) throw new Error(data.message || 'Request failed');
 return data;
}
''')
add('frontend/src/context/AuthContext.jsx', r'''
import {createContext,useContext,useEffect,useState} from 'react';
import {api,getToken,setToken} from '../services/api';
const AuthContext=createContext(null);
export function AuthProvider({children}){
 const [user,setUser]=useState(null); const [loading,setLoading]=useState(Boolean(getToken()));
 useEffect(()=>{if(!getToken()){setLoading(false);return;} api('/auth/me').then(d=>setUser(d.user)).catch(()=>setToken(null)).finally(()=>setLoading(false));},[]);
 async function signIn(email,password){const d=await api('/auth/login',{method:'POST',body:JSON.stringify({email,password})});setToken(d.token);setUser(d.user);return d.user;}
 async function signUp(email,password){const d=await api('/auth/register',{method:'POST',body:JSON.stringify({email,password})});setToken(d.token);setUser(d.user);return d.user;}
 function signOut(){setToken(null);setUser(null);}
 return <AuthContext.Provider value={{user,loading,signIn,signUp,signOut}}>{children}</AuthContext.Provider>;
}
export const useAuth=()=>useContext(AuthContext);
''')

add('frontend/src/components/common/Modal.jsx', r'''
import {useEffect} from 'react';
export default function Modal({title,children,onClose}){useEffect(()=>{const fn=e=>e.key==='Escape'&&onClose();window.addEventListener('keydown',fn);return()=>window.removeEventListener('keydown',fn)},[onClose]);return <div className="modal-backdrop" role="presentation" onMouseDown={e=>e.target===e.currentTarget&&onClose()}><section className="modal" role="dialog" aria-modal="true" aria-label={title}><button className="modal-close" onClick={onClose} aria-label="Close">×</button><p className="eyebrow">THE SELF-GOVERNED GIRL</p><h2>{title}</h2>{children}</section></div>}
''')

add('frontend/src/components/layout/Header.jsx', r'''
import {useEffect,useState} from 'react';
import {api} from '../../services/api';
import {useAuth} from '../../context/AuthContext';
export default function Header({active,onNavigate,onAuth,onScratch,onMothersLetter,onComments}){
 const [count,setCount]=useState({count:0,target:21});const {user,signOut}=useAuth();
 useEffect(()=>{let live=true;const load=()=>api('/community/count').then(d=>live&&setCount(d)).catch(()=>{});load();const timer=setInterval(load,30000);return()=>{live=false;clearInterval(timer)}},[]);
 const nav=[['home','Home'],['community','Community'],['principles','Points to Know'],['five-step','The Five-Step Rule'],['situations','Real-Life Situations'],['compass','Life Compass'],['letters','Letters'],['suggestions','Suggestions'],['know-yourself','Know Yourself']];
 return <header className="site-header"><button className="brand" onClick={()=>onNavigate('home')}><span className="brand-mark">✳</span><span>THE SELF-GOVERNED GIRL</span></button><nav className="main-nav" aria-label="Main navigation">{nav.map(([id,label])=><button key={id} className={active===id?'active':''} onClick={()=>onNavigate(id)}>{label}</button>)}</nav><div className="header-tools"><button className="count-chip" onClick={()=>onNavigate('community')} aria-label={`Community ${count.count} of ${count.target}`}>◉ {String(count.count).padStart(2,'0')} / {count.target}</button><button className="icon-tool" onClick={onComments} aria-label="Comments">✦ <span>Comments</span></button><button className="icon-tool scratch-tool" onClick={onScratch} aria-label="Scratch and Reflect">✧ <span>Scratch</span></button><button className="icon-tool" onClick={onMothersLetter} aria-label="Mom's Letter">❀ <span>Mom’s Letter</span></button>{user?<div className="profile-menu"><span>{user.email}</span>{user.role==='admin'&&<button onClick={()=>onNavigate('admin')}>Admin</button>}<button onClick={signOut}>Sign out</button></div>:<button className="sign-in-button" onClick={onAuth}>Sign in</button>}</div></header>
}
''')

add('frontend/src/components/network/LifeNetwork.jsx', r'''
import {useState} from 'react';
import {compassConnections} from '../../content/lifeCompass';
export default function LifeNetwork({onOpen}){const [selected,setSelected]=useState(null);return <div className="network-wrap"><div className="network-lines" aria-hidden="true">{Array.from({length:14},(_,i)=><span key={i} style={{'--i':i}} />)}</div><div className="network-nodes">{['Self-Awareness','Emotional Awareness','Self-Boundaries','Love','Friendship','Social Influence','Harassment and Intimidation','Intelligence and Strategy','Freedom and Responsibility','Accountability','Five-Step Rule','Real-Life Situations','Know Yourself'].map((node,i)=><button key={node} className={`network-node n${i} ${selected===node?'selected':''}`} onClick={()=>setSelected(selected===node?null:node)}>{node}</button>)}</div>{selected&&<div className="network-detail"><h3>{selected}</h3><p>{compassConnections.find(c=>c.from===selected||c.to===selected)?.why||'Explore this topic and the ways it connects to your choices and circumstances.'}</p><button className="text-link" onClick={()=>onOpen(selected)}>Explore this topic ↗</button></div>}</div>}
''')

add('frontend/src/components/community/CommunityCounter.jsx', r'''
import {useEffect,useState} from 'react';import {api} from '../../services/api';import {useAuth} from '../../context/AuthContext';
export default function CommunityCounter({onAuth}){const [data,setData]=useState({count:0,target:21});const [busy,setBusy]=useState(false);const [message,setMessage]=useState('');const {user}=useAuth();async function refresh(){try{setData(await api('/community/count'))}catch{}}useEffect(()=>{refresh()},[]);async function join(){if(!user){onAuth();return}setBusy(true);setMessage('');try{const d=await api('/community/interest',{method:'POST',body:'{}'});setMessage(d.message);await refresh()}catch(e){setMessage(e.message)}finally{setBusy(false)}}return <section className="community-minimal"><p className="eyebrow">A SMALL STEP TOWARD SOMETHING MEANINGFUL</p><div className="community-number"><span>{String(data.count).padStart(2,'0')}</span><i>/</i><span>{data.target}</span></div><div className="progress-track"><span style={{width:`${Math.min(100,data.target?data.count/data.target*100:0)}%`}}/></div><p className="muted">{Math.max(0,data.target-data.count)} more to reach the first milestone</p><button className="primary-button" disabled={busy} onClick={join}>♡ I'D LIKE TO BE A PART</button>{message&&<p className="status-message" role="status">{message}</p>}<p className="small-note">A genuine expression of interest helps us understand whether to build the next stage.</p></section>}
''')

add('frontend/src/components/community/CommentForm.jsx', r'''
import {useState} from 'react';import {api} from '../../services/api';import {useAuth} from '../../context/AuthContext';
export default function CommentForm({onAuth}){const [message,setMessage]=useState('');const [status,setStatus]=useState('');const [busy,setBusy]=useState(false);const {user}=useAuth();async function submit(e){e.preventDefault();if(!user){onAuth();return}if(!message.trim())return;setBusy(true);setStatus('');try{await api('/comments',{method:'POST',body:JSON.stringify({message})});setMessage('');setStatus('Thank you. Your message has been submitted for review.')}catch(err){setStatus(err.message)}finally{setBusy(false)}}return <form className="comment-form" onSubmit={submit}><label htmlFor="community-message">Share Your Thoughts &amp; Ideas</label><textarea id="community-message" value={message} onChange={e=>setMessage(e.target.value)} maxLength={2000} placeholder="Write a comment or share an idea…" rows={4}/><div className="form-bottom"><span className="muted">{message.length}/2000</span><button className="outline-button" disabled={busy}>{busy?'Sending…':'Share your thought ↗'}</button></div>{status&&<p role="status" className="status-message">{status}</p>}</form>}
''')

add('frontend/src/components/reflections/ScratchCard.jsx', r'''
import {useEffect,useState} from 'react';import {api} from '../../services/api';
export default function ScratchCard(){const [items,setItems]=useState([]);const [index,setIndex]=useState(0);const [revealed,setRevealed]=useState(false);useEffect(()=>{api('/scratch-cards').then(d=>{setItems(d.items||[]);setIndex(Math.floor(Math.random()*(d.items?.length||1))) }).catch(()=>setItems([{category:'Reflection',message:'Pause. Notice what you need. Choose your next step with care.'}]))},[]);function next(){if(items.length>1){let n=index;while(n===index)n=Math.floor(Math.random()*items.length);setIndex(n)}setRevealed(false)}const item=items[index];return <div className="scratch-area">{item?<><p className="eyebrow">{item.category||'A MOMENT TO REFLECT'}</p><button className={`scratch-surface ${revealed?'revealed':''}`} onClick={()=>setRevealed(true)} aria-label={revealed?'Reflection revealed':'Reveal reflection'}>{revealed?<span>{item.message}</span>:<span>✧<br/>Scratch to reveal<br/><small>or tap to reveal</small></span>}</button><button className="text-link" onClick={next}>Another reflection ↻</button></>:<p>Loading reflections…</p>}</div>}
''')

add('frontend/src/components/assessment/Assessment.jsx', r'''
import {useMemo,useState} from 'react';import {assessmentQuestions,assessmentCategories} from '../../content/knowYourselfQuestions';import {principles} from '../../content/principles';
export default function Assessment(){const [answers,setAnswers]=useState({});const [index,setIndex]=useState(0);const [finished,setFinished]=useState(false);const question=assessmentQuestions[index];const selected=answers[question.id];const result=useMemo(()=>{const max=assessmentQuestions.length*4;const score=assessmentQuestions.reduce((s,q)=>s+(answers[q.id]?.score||0),0);const answered=Object.keys(answers).length;const percent=Math.round(score/max*100);const categoryScores=assessmentCategories.map(c=>{const qs=assessmentQuestions.filter(q=>q.category===c.id);const got=qs.reduce((s,q)=>s+(answers[q.id]?.score||0),0);return {...c,score:got,max:qs.length*4,answered:qs.filter(q=>answers[q.id]).length}});return {score,max,answered,percent,categoryScores}},[answers]);const urgent=Object.entries(answers).some(([id,a])=>[2,4,6,7,8,9,10,11,13,15,16,17,18,19,20].includes(Number(id))&&a.score===1&&/unsafe|danger|threat|afraid|pressured|cannot|unable|forced|punish|control|immediate/i.test(a.text+' '+a.feedback));function choose(option){setAnswers(prev=>({...prev,[question.id]:option}))}function reset(){setAnswers({});setIndex(0);setFinished(false)}if(finished){let heading=result.score>=65?'Strong reported awareness':result.score>=49?'Developing consistency':result.score>=33?'Opportunities to strengthen habits':'Begin with simple safety and boundary skills';return <section className="assessment-report"><p className="eyebrow">YOUR REFLECTION REPORT</p><h2>{heading}</h2><div className="score-orbit"><strong>{result.percent}%</strong><span>{result.score} / {result.max}</span></div><p>This reflection is based on your selected answers. It is not a psychological assessment, a diagnosis, or a judgment of your worth or character. Your current circumstances can affect your answers.</p>{urgent&&<div className="urgent-note"><strong>Your immediate wellbeing comes first.</strong><p>If you may be in immediate danger, move toward safety if possible and contact a trusted person or local emergency support. Your score does not matter more than your safety.</p></div>}<h3>Your category reflections</h3>{result.categoryScores.map(c=><div className="category-result" key={c.id}><div><strong>{c.title}</strong><span>{c.score}/{c.max}</span></div><div className="progress-track"><span style={{width:`${c.score/c.max*100}%`}}/></div><p>{c.score/c.max>=.75?'This appears to be a habit you reported using often. Keep practising it consistently.':c.score/c.max>=.5?'You reported some helpful habits here. Choose one practical action to practise next.':'Consider choosing one small, realistic skill in this area and practising it with support when useful.'}</p></div>)}<h3>Strengths to keep building</h3><ul><li>Notice what you already do intentionally and keep practising it.</li><li>Use Pause, Observe, Evaluate, Act, Learn when circumstances allow.</li><li>Ask for help when a situation is difficult or unsafe.</li></ul><h3>What to improve and how</h3><ul><li>Choose one category above and identify one habit you can practise this week.</li><li>Practise a simple phrase such as “I need time to think” when it is safe to say.</li><li>Identify trusted contacts and realistic options before you need them.</li><li>Review a difficult situation without blaming yourself for another person’s behaviour.</li></ul><h3>Explore related lessons</h3><div className="related-links">{principles.slice(0,6).map(p=><span key={p.id}>{p.title}</span>)}</div><p className="small-note">Consistency is about patterns over time, not one answer. Freezing, feeling afraid, or needing help is not weakness. Clothing never causes or justifies harassment.</p><button className="primary-button" onClick={reset}>Reflect again</button></section>}
return <section className="assessment"><div className="assessment-heading"><p className="eyebrow">KNOW YOURSELF · PRIVATE REFLECTION</p><h2>Awareness grows one honest answer at a time.</h2><p>This is a reflection tool, not a test of your worth. Your answers stay in this browser session and are not sent to our server.</p></div><div className="question-meta"><span>{assessmentCategories.find(c=>c.id===question.category)?.title}</span><span>{index+1} / {assessmentQuestions.length}</span></div><div className="progress-track"><span style={{width:`${(index+1)/assessmentQuestions.length*100}%`}}/></div><h3 className="question-title">{question.question}</h3><div className="answer-options">{question.options.map(o=><button key={o.label} className={`answer-option ${selected?.label===o.label?'chosen':''}`} onClick={()=>choose(o)}><span className="option-letter">{o.label}</span><span>{o.text}</span></button>)}</div>{selected&&<div className="answer-feedback"><span className="eyebrow">A MOMENT TO CONSIDER</span><p>{selected.feedback}</p></div>}<div className="assessment-controls"><button className="outline-button" disabled={index===0} onClick={()=>setIndex(i=>i-1)}>← Previous</button>{index<assessmentQuestions.length-1?<button className="primary-button" disabled={!selected} onClick={()=>setIndex(i=>i+1)}>Next question →</button>:<button className="primary-button" disabled={Object.keys(answers).length!==assessmentQuestions.length} onClick={()=>setFinished(true)}>View my reflection →</button>}</div><p className="small-note">Choose the answer that best describes your situation. If you feel unsafe, prioritise safety and support over completing the assessment.</p></section>}
''')

add('frontend/src/App.jsx', r'''
import {useState} from 'react';
import Header from './components/layout/Header';import Modal from './components/common/Modal';import CommunityCounter from './components/community/CommunityCounter';import CommentForm from './components/community/CommentForm';import ScratchCard from './components/reflections/ScratchCard';import Assessment from './components/assessment/Assessment';import LifeNetwork from './components/network/LifeNetwork';import {useAuth} from './context/AuthContext';import {homeContent} from './content/homeContent';import {principles} from './content/principles';import {fiveSteps,fiveStepClosing} from './content/fiveStepRule';import {situations} from './content/realLifeSituations';import {letters} from './content/letters';import {suggestionsContent} from './content/suggestionsContent';import {mothersLetter} from './content/mothersLetter';import {api} from './services/api';
export default function App(){const [active,setActive]=useState('home');const [modal,setModal]=useState(null);const [authMode,setAuthMode]=useState('login');const [authEmail,setAuthEmail]=useState('');const [authPassword,setAuthPassword]=useState('');const [authError,setAuthError]=useState('');const [authBusy,setAuthBusy]=useState(false);const [suggestion,setSuggestion]=useState('');const [suggestionStatus,setSuggestionStatus]=useState('');const [selectedPrinciple,setSelectedPrinciple]=useState(null);const {user,signIn,signUp}=useAuth();function navigate(id){setActive(id);setSelectedPrinciple(null);window.scrollTo({top:0,behavior:'smooth'})}function openAuth(){setAuthError('');setModal('auth')}async function submitAuth(e){e.preventDefault();setAuthBusy(true);setAuthError('');try{if(authMode==='login')await signIn(authEmail,authPassword);else await signUp(authEmail,authPassword);setModal(null);setAuthPassword('');if(active==='admin')navigate('admin')}catch(e){setAuthError(e.message)}finally{setAuthBusy(false)}}async function submitSuggestion(e){e.preventDefault();if(!user){openAuth();return}try{await api('/suggestions',{method:'POST',body:JSON.stringify({message:suggestion})});setSuggestion('');setSuggestionStatus('Thank you. Your suggestion has been sent for review.')}catch(e){setSuggestionStatus(e.message)}}function openTopic(title){const p=principles.find(x=>x.title.toLowerCase()===title.toLowerCase());if(p){setSelectedPrinciple(p);navigate('principles')}else if(title==='Know Yourself')navigate('know-yourself');else if(title==='Five-Step Rule')navigate('five-step');else if(title==='Real-Life Situations')navigate('situations');else navigate('principles')}
const titleMap={home:'Home',community:'Community',principles:'Points to Know','five-step':'The Five-Step Rule',situations:'Real-Life Situations',compass:'Life Compass',letters:'Letters',suggestions:'Suggestions','know-yourself':'Know Yourself',admin:'Admin Panel'};
return <div className="app-shell"><Header active={active} onNavigate={navigate} onAuth={openAuth} onScratch={()=>setModal('scratch')} onMothersLetter={()=>setModal('mother')} onComments={()=>{navigate('community');setTimeout(()=>document.getElementById('community-message')?.focus(),350)}}/><main id="main-content">
{active==='home'&&<><section className="hero section-wrap"><p className="eyebrow">{homeContent.eyebrow}</p><h1>{homeContent.title}</h1><p className="hero-tagline">{homeContent.tagline}</p><div className="hero-copy"><p>{homeContent.introduction}</p><p>{homeContent.purpose}</p></div><div className="pillar-list">{homeContent.pillars.map(p=><div className="pillar" key={p.number}><span>{p.number}</span><div><h3>{p.title}</h3><p>{p.text}</p></div></div>)}</div><div className="remember-block"><p className="eyebrow">{homeContent.rememberTitle}</p><blockquote>{homeContent.remember}</blockquote></div><p className="essence">{homeContent.essence}</p><button className="text-link" onClick={()=>navigate('principles')}>Explore the guide ↓</button></section><section className="section-wrap home-network"><p className="eyebrow">A CONNECTED GUIDE</p><h2>Every part of life touches another.</h2><LifeNetwork onOpen={openTopic}/></section><section className="transition-band"><p>{homeContent.transition}</p><button className="outline-button" onClick={()=>navigate('community')}>Explore the community ↗</button></section></>}
{active==='community'&&<section className="section-wrap page-section"><p className="eyebrow">COMMUNITY</p><h1>Small steps. Shared understanding.</h1><CommunityCounter onAuth={openAuth}/><div className="community-comments" id="community-comments"><span className="section-line"/><CommentForm onAuth={openAuth}/></div></section>}
{active==='principles'&&<section className="section-wrap page-section"><p className="eyebrow">22 PRINCIPLES</p><h1>Points to Know</h1><p className="lead">Understand the principle. Consider the reality. Choose your response.</p>{selectedPrinciple&&<article className="detail-feature"><button className="modal-close inline-close" onClick={()=>setSelectedPrinciple(null)}>×</button><span className="eyebrow">{String(selectedPrinciple.id).padStart(2,'0')}</span><h2>{selectedPrinciple.title}</h2><h3>{selectedPrinciple.subtitle}</h3><p>{selectedPrinciple.meaning}</p><p>{selectedPrinciple.guidance}</p><blockquote>{selectedPrinciple.takeaway}</blockquote><button className="text-link" onClick={()=>navigate('five-step')}>Connect to the Five-Step Rule ↗</button></article>}<div className="principle-list">{principles.map(p=><button key={p.id} className="principle-row" onClick={()=>setSelectedPrinciple(p)}><span>{String(p.id).padStart(2,'0')}</span><div><h2>{p.title}</h2><p>{p.subtitle}</p></div><b>↗</b></button>)}</div></section>}
{active==='five-step'&&<section className="section-wrap page-section"><p className="eyebrow">A PRACTICAL WAY TO THINK</p><h1>THE FIVE-STEP RULE FOR ANY SITUATION</h1><div className="steps-list">{fiveSteps.map(s=><article className="step-row" key={s.number}><span className="step-number">{s.number}</span><div><h2>{s.title}</h2><p>{s.text}</p><details><summary>Explore this step</summary><p>{s.detail}</p></details></div></article>)}</div><blockquote className="closing-quote">{fiveStepClosing}</blockquote></section>}
{active==='situations'&&<section className="section-wrap page-section"><p className="eyebrow">REAL LIFE, REAL CHOICES</p><h1>Real-Life Situations</h1><p className="lead">There is not always one perfect response. Consider your circumstances and choose the safest realistic option.</p><div className="situation-list">{situations.map(s=><article className="situation-row" key={s.id}><p className="eyebrow">SITUATION / {s.id.toUpperCase()}</p><h2>{s.title}</h2><p>{s.intro}</p><h3>What to notice</h3><ul>{s.signs.map(x=><li key={x}>{x}</li>)}</ul><h3>Options to consider</h3><ul>{s.options.map(x=><li key={x}>{x}</li>)}</ul><blockquote>{s.lesson}</blockquote></article>)}</div></section>}
{active==='compass'&&<section className="section-wrap page-section"><p className="eyebrow">THE CONNECTED VIEW</p><h1>Life Compass</h1><p className="lead">Choose a node to explore how one lesson connects with another.</p><LifeNetwork onOpen={openTopic}/><div className="connection-list">{principles.map(p=><button key={p.id} onClick={()=>openTopic(p.title)}>{p.title} <span>Explore ↗</span></button>)}</div></section>}
{active==='letters'&&<section className="section-wrap page-section"><p className="eyebrow">LETTERS FOR REAL LIFE</p><h1>Letters</h1><div className="letters-list">{letters.map(l=><article className="letter" key={l.id}><p className="eyebrow">A LETTER TO KEEP</p><h2>{l.title}</h2><p className="letter-opening">{l.opening}</p><p>{l.body}</p><blockquote>{l.takeaway}</blockquote><button className="text-link" onClick={()=>openTopic(principles.find(p=>p.id===l.related[0])?.title||'Self-Awareness')}>Explore a related lesson ↗</button></article>)}</div></section>}
{active==='suggestions'&&<section className="section-wrap page-section"><p className="eyebrow">YOUR IDEAS MATTER</p><h1>{suggestionsContent.title}</h1><p className="lead">{suggestionsContent.intro}</p><form className="suggestion-form" onSubmit={submitSuggestion}><label htmlFor="suggestion">{suggestionsContent.prompt}</label><textarea id="suggestion" value={suggestion} onChange={e=>setSuggestion(e.target.value)} maxLength={3000} rows={6} placeholder="Write your suggestion…" required/><p className="small-note">{suggestionsContent.note}</p><button className="primary-button">Submit suggestion ↗</button>{suggestionStatus&&<p role="status">{suggestionStatus}</p>}</form></section>}
{active==='know-yourself'&&<section className="section-wrap page-section"><h1>Know Yourself</h1><Assessment/></section>}
{active==='admin'&&<AdminPage onAuth={openAuth} user={user}/>}
</main><footer className="site-footer"><span>THE SELF-GOVERNED GIRL</span><p>Know yourself. Understand reality. Protect your dignity. Govern your life.</p><button className="text-link" onClick={()=>navigate('home')}>Back to the beginning ↑</button></footer>
{modal==='auth'&&<Modal title={authMode==='login'?'Welcome back':'Create your account'} onClose={()=>setModal(null)}><div className="auth-switch"><button className={authMode==='login'?'active':''} onClick={()=>{setAuthMode('login');setAuthError('')}}>Sign in</button><button className={authMode==='signup'?'active':''} onClick={()=>{setAuthMode('signup');setAuthError('')}}>Create account</button></div><form className="auth-form" onSubmit={submitAuth}><label>Email<input type="email" value={authEmail} onChange={e=>setAuthEmail(e.target.value)} required autoComplete="email"/></label><label>Password<input type="password" value={authPassword} onChange={e=>setAuthPassword(e.target.value)} required minLength={8} autoComplete={authMode==='login'?'current-password':'new-password'}/></label>{authError&&<p className="error-message">{authError}</p>}<button className="primary-button" disabled={authBusy}>{authBusy?'Please wait…':authMode==='login'?'Sign in':'Create account'}</button><p className="small-note">Public learning content is available without an account. Sign in is required to register community interest or send a comment.</p></form></Modal>}
{modal==='scratch'&&<Modal title="Scratch & Reflect" onClose={()=>setModal(null)}><p className="muted">A small question to bring your attention back to yourself.</p><ScratchCard/></Modal>}
{modal==='mother'&&<Modal title="Mom’s Letter" onClose={()=>setModal(null)}><div className="mother-letter">{mothersLetter.split('\n').map((line,i)=><p key={i}>{line||' '}</p>)}</div><p className="small-note">Let this be a gentle reflection, not a rule or a source of shame. You can seek wisdom from any trusted, supportive person in your life.</p></Modal>}
</div>}
function AdminPage({onAuth,user}){const [tab,setTab]=useState('dashboard');const [data,setData]=useState(null);const [items,setItems]=useState([]);const [target,setTarget]=useState(21);const [newMessage,setNewMessage]=useState('');const [newCategory,setNewCategory]=useState('Awareness & Preparedness');const [status,setStatus]=useState('');async function load(){try{const d=await api('/admin/dashboard');setData(d);setTarget(d.target||21);if(tab==='participants')setItems((await api('/admin/participants')).items||[]);if(tab==='comments')setItems((await api('/admin/comments')).items||[]);if(tab==='scratch')setItems((await api('/admin/scratch-cards')).items||[])}catch(e){setStatus(e.message)}}useState(()=>{});importEffect(load,[tab,user]);if(!user){return <section className="section-wrap page-section"><h1>Admin Panel</h1><p>Sign in with the authorised administrator account to continue.</p><button className="primary-button" onClick={onAuth}>Sign in</button></section>}if(user.role!=='admin')return <section className="section-wrap page-section"><h1>Access restricted</h1><p>This area is only available to an authorised administrator.</p></section>;async function saveTarget(){try{await api('/admin/settings',{method:'PUT',body:JSON.stringify({target:Number(target)})});setStatus('Community target saved.');await load()}catch(e){setStatus(e.message)}}async function saveScratch(){try{await api('/admin/scratch-cards',{method:'POST',body:JSON.stringify({category:newCategory,message:newMessage})});setNewMessage('');setStatus('Scratch message added.');await load()}catch(e){setStatus(e.message)}}async function toggleScratch(item){try{await api(`/admin/scratch-cards/${item._id}`,{method:'PATCH',body:JSON.stringify({enabled:!item.enabled})});await load()}catch(e){setStatus(e.message)}}async function deleteScratch(item){if(!confirm('Delete this scratch message?'))return;try{await api(`/admin/scratch-cards/${item._id}`,{method:'DELETE'});await load()}catch(e){setStatus(e.message)}}async function moderate(item,statusValue){try{await api(`/admin/comments/${item._id}`,{method:'PATCH',body:JSON.stringify({status:statusValue})});await load()}catch(e){setStatus(e.message)}}return <section className="section-wrap page-section admin-page"><p className="eyebrow">PRIVATE · ADMINISTRATOR ONLY</p><h1>Admin Panel</h1><div className="admin-tabs">{[['dashboard','Dashboard'],['settings','Community Count'],['participants','Participants'],['comments','Messages & Ideas'],['scratch','Scratch Manager']].map(([id,label])=><button key={id} className={tab===id?'active':''} onClick={()=>setTab(id)}>{label}</button>)}</div>{status&&<p role="status" className="status-message">{status}</p>}{tab==='dashboard'&&<div className="admin-stats">{[['Actual interests',data?.count??'—'],['Target',data?.target??'—'],['Comments',data?.comments??'—'],['Scratch messages',data?.scratchCards??'—']].map(([label,value])=><article key={label}><span>{label}</span><strong>{value}</strong></article>)}<button className="outline-button" onClick={load}>Refresh statistics ↻</button></div>}{tab==='settings'&&<div className="admin-panel"><h2>Community milestone target</h2><p>The actual participant count is calculated from unique registrations and cannot be manually falsified.</p><label>Target<input type="number" min="1" max="1000000" value={target} onChange={e=>setTarget(e.target.value)}/></label><button className="primary-button" onClick={saveTarget}>Save target</button></div>}{tab==='participants'&&<div className="admin-panel"><h2>Registered participants</h2>{items.map(i=><div className="admin-row" key={i._id}><span>{i.user?.email||'Account'}</span><span>{new Date(i.createdAt).toLocaleString()}</span></div>)}</div>}{tab==='comments'&&<div className="admin-panel"><h2>Messages &amp; Ideas</h2>{items.map(i=><div className="admin-row stacked" key={i._id}><strong>{i.user?.email||'User'} · {i.status}</strong><p>{i.message}</p><div><button className="text-link" onClick={()=>moderate(i,'reviewed')}>Mark reviewed</button><button className="text-link" onClick={()=>moderate(i,'hidden')}>Hide</button></div></div>)}</div>}{tab==='scratch'&&<div className="admin-panel"><h2>Scratch &amp; Reflect Manager</h2><form className="scratch-admin-form" onSubmit={e=>{e.preventDefault();saveScratch()}}><label>Category<input value={newCategory} onChange={e=>setNewCategory(e.target.value)} required/></label><label>Message<textarea value={newMessage} onChange={e=>setNewMessage(e.target.value)} maxLength={1000} required/></label><button className="primary-button">Add message</button></form>{items.map(i=><div className="admin-row stacked" key={i._id}><strong>{i.category} · {i.enabled?'Enabled':'Disabled'}</strong><p>{i.message}</p><div><button className="text-link" onClick={()=>toggleScratch(i)}>{i.enabled?'Disable':'Enable'}</button><button className="text-link" onClick={()=>deleteScratch(i)}>Delete</button></div></div>)}</div>}</section>}
function importEffect(fn,deps){const ReactHooks=globalThis.__unusedReactHooks;/* placeholder removed by compiler-safe wrapper below */}
''')

# Replace the accidental hook shim with a real useEffect import/useEffect call in AdminPage.
files['frontend/src/App.jsx'] = files['frontend/src/App.jsx'].replace("import {useState} from 'react';", "import {useState,useEffect} from 'react';")
files['frontend/src/App.jsx'] = files['frontend/src/App.jsx'].replace("useState(()=>{});importEffect(load,[tab,user]);", "useEffect(()=>{if(user?.role==='admin')load();},[tab,user]);")
files['frontend/src/App.jsx'] = files['frontend/src/App.jsx'].replace("\nfunction importEffect(fn,deps){const ReactHooks=globalThis.__unusedReactHooks;/* placeholder removed by compiler-safe wrapper below */}\n", "\n")

add('frontend/src/main.jsx', r'''
import React from 'react';import{createRoot}from'react-dom/client';import App from './App';import{AuthProvider}from'./context/AuthContext';import'./styles/global.css';
createRoot(document.getElementById('root')).render(<React.StrictMode><AuthProvider><App/></AuthProvider></React.StrictMode>);
''')

add('frontend/src/styles/global.css', r'''
@import url('https://fonts.googleapis.com/css2?family=DM+Mono:wght@400;500&family=Manrope:wght@400;500;600;700;800&family=Playfair+Display:ital,wght@0,500;0,600;1,500&display=swap');
:root{font-family:Manrope,system-ui,sans-serif;color:#f1f0fa;background:#080b18;font-synthesis:none;text-rendering:optimizeLegibility;--bg:#080b18;--panel:#10152a;--text:#f1f0fa;--muted:#a7adc6;--violet:#b4a0ff;--blue:#72d8ff;--pink:#f3a7d8;--line:rgba(181,173,255,.2);--mono:'DM Mono',monospace}*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;min-width:320px;background:radial-gradient(ellipse at 80% 0%,rgba(91,66,166,.17),transparent 42%),radial-gradient(ellipse at 5% 38%,rgba(36,112,145,.09),transparent 34%),var(--bg);color:var(--text)}button,input,textarea{font:inherit}button{color:inherit;cursor:pointer}button:focus-visible,input:focus-visible,textarea:focus-visible,summary:focus-visible{outline:2px solid var(--blue);outline-offset:4px}button:disabled{opacity:.5;cursor:not-allowed}p{line-height:1.8;color:#d0d3e3}h1,h2,h3,p{margin-top:0}h1{font-size:clamp(2.6rem,8vw,6.8rem);letter-spacing:-.07em;line-height:.98;margin-bottom:1.4rem;font-weight:700}h2{letter-spacing:-.04em;line-height:1.15}h3{line-height:1.35}.site-header{position:sticky;top:0;z-index:30;background:rgba(8,11,24,.88);backdrop-filter:blur(18px);border-bottom:1px solid var(--line);padding:.75rem clamp(1rem,3vw,2.5rem);display:flex;align-items:center;gap:1rem;flex-wrap:wrap}.brand{display:flex;align-items:center;gap:.55rem;background:none;border:0;font-size:.72rem;letter-spacing:.09em;font-weight:800;white-space:nowrap}.brand-mark{font-size:1.5rem;color:var(--violet);text-shadow:0 0 16px var(--violet)}.main-nav{display:flex;gap:.15rem;flex:1;justify-content:center;flex-wrap:wrap}.main-nav button,.icon-tool,.profile-menu button{background:transparent;border:0;color:var(--muted);font-size:.72rem;padding:.5rem .55rem;border-radius:999px}.main-nav button:hover,.main-nav button.active,.icon-tool:hover{color:#fff;background:rgba(174,156,255,.1)}.header-tools{display:flex;align-items:center;gap:.25rem}.count-chip{background:rgba(114,216,255,.08);border:1px solid rgba(114,216,255,.35);border-radius:999px;padding:.5rem .65rem;color:var(--blue);font-family:var(--mono);font-size:.72rem;white-space:nowrap}.icon-tool{white-space:nowrap}.icon-tool:first-letter{color:var(--pink)}.scratch-tool{color:var(--violet);animation:softGlow 3s ease-in-out infinite}.sign-in-button,.primary-button{background:linear-gradient(110deg,#b9a5ff,#7cddff);color:#101326;border:0;border-radius:999px;padding:.85rem 1.2rem;font-weight:800;font-size:.82rem}.sign-in-button{padding:.55rem .8rem}.profile-menu{display:flex;align-items:center;gap:.3rem;font-size:.7rem;color:var(--muted)}.profile-menu span{max-width:120px;overflow:hidden;text-overflow:ellipsis}.section-wrap{width:min(1120px,calc(100% - 2.5rem));margin-inline:auto}.hero{padding:clamp(4rem,10vw,8rem) 0 5rem}.eyebrow{font-family:var(--mono);font-size:.7rem;letter-spacing:.16em;text-transform:uppercase;color:var(--blue);margin-bottom:1.3rem}.hero h1{max-width:1000px}.hero-tagline{font-size:clamp(1.05rem,2.7vw,1.55rem);color:var(--violet);max-width:800px;line-height:1.55}.hero-copy{max-width:760px;margin:3rem 0;color:#c5c9dc}.hero-copy p{font-size:1.05rem}.pillar-list{display:grid;grid-template-columns:repeat(5,1fr);border-top:1px solid var(--line);border-bottom:1px solid var(--line);margin:4rem 0}.pillar{padding:1.4rem 1rem;border-right:1px solid var(--line)}.pillar:last-child{border:0}.pillar>span,.principle-row>span{font: .72rem var(--mono);color:var(--pink)}.pillar h3{font-size:1.05rem;margin:.8rem 0}.pillar p{font-size:.82rem;line-height:1.6;color:var(--muted)}.remember-block{max-width:900px;margin:5rem 0}.remember-block blockquote,.closing-quote{font-family:'Playfair Display',serif;font-size:clamp(1.5rem,3.5vw,2.5rem);line-height:1.45;margin:0;border-left:2px solid var(--violet);padding-left:1.4rem;color:#f5efff}.essence{max-width:760px;font-size:1.12rem;color:#d6d8e8;margin:3rem 0}.text-link{border:0;background:none;color:var(--blue);padding:.5rem 0;font-size:.85rem;text-align:left}.text-link:hover{text-decoration:underline}.home-network{padding:4rem 0 7rem}.home-network h2{font-size:clamp(2rem,5vw,3.5rem);max-width:700px}.transition-band{padding:3rem 1.25rem;text-align:center;background:linear-gradient(90deg,transparent,rgba(123,105,209,.12),transparent);border-block:1px solid var(--line)}.transition-band p{font-family:'Playfair Display',serif;font-size:1.5rem}.outline-button{border:1px solid rgba(180,160,255,.5);border-radius:999px;background:transparent;padding:.8rem 1.1rem;color:var(--violet);font-size:.82rem}.outline-button:hover{background:rgba(180,160,255,.1)}.page-section{padding:5rem 0 7rem;min-height:60vh}.page-section>h1{font-size:clamp(2.8rem,7vw,5.5rem)}.lead{font-size:1.1rem;color:var(--muted);max-width:760px;margin-bottom:3rem}.community-minimal{max-width:520px;margin:4rem auto 3rem;text-align:center}.community-number{display:flex;justify-content:center;align-items:baseline;gap:1rem;font:clamp(4rem,15vw,8rem) var(--mono);letter-spacing:-.1em;margin:1.5rem 0}.community-number i{font-style:normal;color:var(--violet);font-size:.5em}.progress-track{height:3px;border-radius:99px;background:rgba(180,160,255,.15);overflow:hidden}.progress-track span{display:block;height:100%;background:linear-gradient(90deg,var(--violet),var(--blue));box-shadow:0 0 14px var(--blue);transition:width .5s ease}.muted,.small-note{color:var(--muted);font-size:.82rem}.community-minimal .primary-button{margin-top:1.4rem}.small-note{line-height:1.65;margin-top:1.3rem}.status-message{color:var(--blue);font-size:.85rem}.community-comments{max-width:680px;margin:4rem auto 0}.section-line{display:block;height:1px;background:var(--line);margin-bottom:3rem}.comment-form label,.suggestion-form label,.auth-form label,.admin-panel label{display:block;font-size:.9rem;font-weight:700;margin-bottom:.8rem}.comment-form textarea,.suggestion-form textarea,.auth-form input,.admin-panel input,.scratch-admin-form input,.scratch-admin-form textarea{width:100%;background:#0d1224;color:var(--text);border:1px solid var(--line);border-radius:14px;padding:1rem;resize:vertical;margin:.65rem 0 1rem}.form-bottom{display:flex;justify-content:space-between;align-items:center}.principle-list{border-top:1px solid var(--line)}.principle-row{display:flex;align-items:center;gap:1.3rem;width:100%;padding:1.5rem .5rem;border:0;border-bottom:1px solid var(--line);background:transparent;text-align:left}.principle-row:hover{background:rgba(180,160,255,.055)}.principle-row div{flex:1}.principle-row h2{font-size:1.3rem;margin:0 0 .35rem}.principle-row p{color:var(--muted);margin:0;font-size:.85rem}.principle-row b{font-size:1.3rem;color:var(--violet)}.detail-feature{position:relative;border:1px solid rgba(180,160,255,.35);border-radius:20px;padding:2rem;margin:2rem 0 3rem;background:rgba(19,23,45,.7)}.detail-feature h2{font-size:2rem}.detail-feature h3{color:var(--violet)}.detail-feature blockquote,.situation-row blockquote,.letter blockquote{font-family:'Playfair Display',serif;font-size:1.3rem;color:#e9e3ff;border-left:2px solid var(--pink);padding-left:1rem}.inline-close{position:absolute;right:1rem;top:1rem}.steps-list{margin:4rem 0}.step-row{display:grid;grid-template-columns:90px 1fr;gap:1.5rem;padding:2rem 0;border-bottom:1px solid var(--line)}.step-number{font:1.4rem var(--mono);color:var(--pink)}.step-row h2{font-size:clamp(1.6rem,3vw,2.3rem);margin-bottom:.7rem}.step-row details{color:var(--blue);margin-top:1rem}.step-row summary{cursor:pointer}.closing-quote{margin-top:4rem;max-width:900px}.situation-list,.letters-list{display:grid;grid-template-columns:1fr 1fr;gap:1rem}.situation-row,.letter{padding:2rem;border:1px solid var(--line);border-radius:20px;background:linear-gradient(140deg,rgba(22,27,52,.8),rgba(13,17,33,.4))}.situation-row h2,.letter h2{font-size:1.8rem}.situation-row h3{font-size:.9rem;color:var(--violet);margin:1.5rem 0 .5rem}.situation-row li{color:#c4c9db;line-height:1.7;margin:.35rem 0}.letter-opening{font-family:'Playfair Display',serif;font-size:1.3rem;color:var(--pink)}.network-wrap{position:relative;min-height:430px;overflow:hidden;border:1px solid var(--line);border-radius:24px;background:radial-gradient(circle at center,rgba(82,76,154,.14),transparent 65%);padding:2rem;margin:2rem 0}.network-lines{position:absolute;inset:0;pointer-events:none}.network-lines span{position:absolute;left:50%;top:50%;width:80%;height:1px;background:linear-gradient(90deg,transparent,rgba(114,216,255,.35),rgba(180,160,255,.4),transparent);transform:rotate(calc(var(--i)*25deg));transform-origin:center;animation:threadPulse 5s ease-in-out infinite alternate;opacity:.65}.network-nodes{position:relative;min-height:370px}.network-node{position:absolute;max-width:175px;background:rgba(12,17,36,.9);border:1px solid rgba(180,160,255,.45);border-radius:999px;padding:.7rem .9rem;font-size:.75rem;color:#e7e4ff;box-shadow:0 0 20px rgba(180,160,255,.06);transition:.25s}.network-node:hover,.network-node.selected{border-color:var(--blue);box-shadow:0 0 24px rgba(114,216,255,.28);color:#fff}.n0{left:5%;top:10%}.n1{left:35%;top:4%}.n2{right:5%;top:13%}.n3{left:17%;top:32%}.n4{right:20%;top:34%}.n5{left:4%;top:57%}.n6{right:4%;top:58%}.n7{left:34%;top:52%}.n8{left:28%;bottom:6%}.n9{right:8%;bottom:7%}.n10{left:45%;top:28%}.n11{left:43%;bottom:2%}.n12{left:65%;bottom:23%}.network-detail{position:relative;background:#151a33;border:1px solid var(--line);padding:1rem 1.3rem;border-radius:16px;margin-top:1rem}.network-detail h3{margin-bottom:.4rem}.connection-list{display:flex;flex-wrap:wrap;gap:.5rem}.connection-list button{background:transparent;border:1px solid var(--line);border-radius:999px;padding:.65rem .85rem;font-size:.78rem}.connection-list span{color:var(--blue);margin-left:.5rem}.assessment{max-width:850px;margin:3rem auto}.assessment-heading{max-width:700px;margin-bottom:3rem}.assessment-heading h2{font-size:clamp(1.8rem,4vw,3rem)}.question-meta{display:flex;justify-content:space-between;color:var(--blue);font: .7rem var(--mono);text-transform:uppercase;letter-spacing:.08em;margin-bottom:1rem}.question-title{font-size:clamp(1.5rem,4vw,2.3rem);margin:2.2rem 0}.answer-options{display:grid;gap:.7rem}.answer-option{display:flex;gap:1rem;align-items:flex-start;text-align:left;padding:1rem;border:1px solid var(--line);border-radius:15px;background:rgba(17,22,43,.7);line-height:1.6}.answer-option.chosen{border-color:var(--blue);background:rgba(114,216,255,.08)}.option-letter{display:grid;place-items:center;flex:0 0 32px;height:32px;border:1px solid var(--line);border-radius:50%;font: .8rem var(--mono);color:var(--violet)}.answer-feedback{border-left:2px solid var(--pink);padding:1.1rem 1.3rem;margin:1.4rem 0;background:rgba(243,167,216,.045)}.answer-feedback p{margin:0}.assessment-controls{display:flex;justify-content:space-between;gap:1rem;margin:2rem 0}.assessment-report{max-width:850px;margin:3rem auto}.score-orbit{width:160px;height:160px;border:1px solid var(--violet);border-radius:50%;display:flex;flex-direction:column;justify-content:center;align-items:center;box-shadow:0 0 35px rgba(180,160,255,.15);margin:2rem 0}.score-orbit strong{font-size:2.5rem}.score-orbit span{font: .75rem var(--mono);color:var(--muted)}.category-result{border-bottom:1px solid var(--line);padding:1rem 0}.category-result>div:first-child{display:flex;justify-content:space-between;margin-bottom:.7rem}.category-result span{font: .75rem var(--mono);color:var(--blue)}.category-result p{font-size:.85rem}.urgent-note{border:1px solid rgba(243,167,216,.5);border-radius:16px;padding:1.2rem;margin:1.5rem 0}.urgent-note strong{color:var(--pink)}.related-links{display:flex;gap:.5rem;flex-wrap:wrap}.related-links span{border:1px solid var(--line);border-radius:99px;padding:.5rem .7rem;font-size:.75rem}.suggestion-form{max-width:720px;margin-top:3rem}.auth-switch{display:flex;gap:.5rem;margin-bottom:1.5rem}.auth-switch button{border:1px solid var(--line);background:transparent;padding:.6rem 1rem;border-radius:999px}.auth-switch button.active{border-color:var(--violet);color:var(--violet)}.auth-form .primary-button{width:100%;margin-top:.5rem}.error-message{color:#ff9bb6}.modal-backdrop{position:fixed;inset:0;z-index:100;background:rgba(3,5,14,.8);backdrop-filter:blur(12px);display:grid;place-items:center;padding:1rem}.modal{position:relative;width:min(620px,100%);max-height:90vh;overflow:auto;padding:clamp(1.5rem,5vw,2.5rem);border:1px solid rgba(180,160,255,.4);border-radius:24px;background:linear-gradient(150deg,#171b35,#0c1021);box-shadow:0 25px 100px rgba(0,0,0,.45)}.modal h2{font-size:2rem}.modal-close{position:absolute;right:1rem;top:1rem;border:0;background:transparent;color:var(--muted);font-size:1.7rem}.scratch-area{text-align:center}.scratch-surface{width:100%;min-height:180px;border:1px solid rgba(180,160,255,.4);border-radius:18px;background:repeating-linear-gradient(135deg,#7771a2 0,#7771a2 8px,#625d89 8px,#625d89 16px);color:white;font-size:1.2rem;font-weight:700;padding:2rem;margin:1rem 0;box-shadow:inset 0 0 35px rgba(0,0,0,.18)}.scratch-surface.revealed{background:radial-gradient(circle at top right,rgba(114,216,255,.16),transparent 60%),#11172d;border-color:var(--blue)}.scratch-surface small{font-size:.7rem;font-weight:400}.mother-letter{font-family:'Playfair Display',serif;font-size:1.2rem;line-height:1.8}.mother-letter p{white-space:pre-wrap}.admin-tabs{display:flex;gap:.4rem;flex-wrap:wrap;margin:2rem 0}.admin-tabs button{background:transparent;border:1px solid var(--line);border-radius:999px;padding:.7rem .9rem;font-size:.75rem}.admin-tabs button.active{border-color:var(--blue);color:var(--blue)}.admin-stats{display:grid;grid-template-columns:repeat(2,1fr);gap:1rem}.admin-stats article,.admin-panel{border:1px solid var(--line);border-radius:16px;padding:1.3rem;background:rgba(18,23,45,.6)}.admin-stats article span{display:block;color:var(--muted);font-size:.8rem}.admin-stats article strong{display:block;font-size:2rem;margin-top:.5rem}.admin-panel{margin-top:1rem}.admin-panel label input{display:block;max-width:320px}.admin-row{display:flex;gap:1rem;justify-content:space-between;align-items:center;padding:1rem 0;border-bottom:1px solid var(--line);font-size:.85rem}.admin-row:last-child{border-bottom:0}.admin-row.stacked{display:block}.admin-row.stacked p{overflow-wrap:anywhere}.admin-row .text-link{margin-right:1rem}.scratch-admin-form{display:grid;gap:.5rem;margin-bottom:2rem}.site-footer{border-top:1px solid var(--line);padding:3rem clamp(1.25rem,5vw,5rem);display:flex;align-items:center;justify-content:space-between;gap:1rem;flex-wrap:wrap}.site-footer>span{font-size:.75rem;letter-spacing:.1em;font-weight:800}.site-footer p{font-size:.75rem;color:var(--muted);margin:0}@keyframes softGlow{0%,100%{text-shadow:0 0 4px rgba(180,160,255,.3)}50%{text-shadow:0 0 15px rgba(180,160,255,.9)}}@keyframes threadPulse{from{opacity:.15}to{opacity:.65}}@media(max-width:1200px){.site-header{gap:.4rem}.main-nav{order:3;flex-basis:100%;justify-content:flex-start;overflow-x:auto;flex-wrap:nowrap}.main-nav button{flex-shrink:0}.header-tools{margin-left:auto}}@media(max-width:760px){.section-wrap{width:calc(100% - 2rem)}.site-header{padding:.6rem .8rem}.brand{font-size:.65rem}.header-tools .icon-tool span{display:none}.header-tools .icon-tool{padding:.45rem}.profile-menu span{display:none}.main-nav{gap:0}.main-nav button{font-size:.68rem;padding:.5rem .65rem}.pillar-list{grid-template-columns:1fr 1fr}.pillar{border-bottom:1px solid var(--line)}.pillar:nth-child(2n){border-right:0}.pillar:last-child{grid-column:1/-1}.hero{padding-top:4rem}.situation-list,.letters-list{grid-template-columns:1fr}.network-wrap{padding:1rem;min-height:480px}.network-nodes{min-height:420px}.network-node{max-width:135px;font-size:.67rem;padding:.55rem .65rem}.n0{left:0;top:5%}.n1{left:36%;top:0}.n2{right:0;top:8%}.n3{left:0;top:27%}.n4{right:0;top:29%}.n5{left:0;top:49%}.n6{right:0;top:51%}.n7{left:30%;top:23%}.n8{left:7%;bottom:9%}.n9{right:0;bottom:5%}.n10{left:40%;top:43%}.n11{left:28%;bottom:0}.n12{right:0;bottom:25%}.step-row{grid-template-columns:45px 1fr;gap:.8rem}.admin-stats{grid-template-columns:1fr}.site-footer{display:block}.site-footer p{margin:.8rem 0}.community-number{font-size:5rem}.assessment-controls{align-items:stretch}.assessment-controls button{font-size:.75rem}.modal{padding:1.5rem}.header-tools{gap:0}.count-chip{font-size:.65rem;padding:.45rem}.icon-tool{font-size:.8rem!important}}@media(prefers-reduced-motion:reduce){*,*::before,*::after{scroll-behavior:auto!important;animation-duration:.01ms!important;animation-iteration-count:1!important;transition-duration:.01ms!important}}
''')

# Backend configuration and models
add('backend/src/config/database.js', r'''
import mongoose from 'mongoose';
export async function connectDatabase(){if(!process.env.MONGODB_URI)throw new Error('MONGODB_URI is missing. Fill backend/.env first.');await mongoose.connect(process.env.MONGODB_URI);console.log('MongoDB Atlas connected.');}
''')
add('backend/src/models/User.js', r'''
import mongoose from 'mongoose';
const userSchema=new mongoose.Schema({email:{type:String,required:true,unique:true,lowercase:true,trim:true,index:true},passwordHash:{type:String,required:true,select:false},role:{type:String,enum:['user','admin'],default:'user',index:true}},{timestamps:true});
export default mongoose.model('User',userSchema);
''')
add('backend/src/models/CommunityInterest.js', r'''
import mongoose from 'mongoose';
const schema=new mongoose.Schema({user:{type:mongoose.Schema.Types.ObjectId,ref:'User',required:true,unique:true,index:true}},{timestamps:true});
export default mongoose.model('CommunityInterest',schema);
''')
add('backend/src/models/Comment.js', r'''
import mongoose from 'mongoose';
const schema=new mongoose.Schema({user:{type:mongoose.Schema.Types.ObjectId,ref:'User',required:true},message:{type:String,required:true,trim:true,maxlength:2000},status:{type:String,enum:['pending','reviewed','hidden'],default:'pending',index:true}},{timestamps:true});
export default mongoose.model('Comment',schema);
''')
add('backend/src/models/Suggestion.js', r'''
import mongoose from 'mongoose';
const schema=new mongoose.Schema({user:{type:mongoose.Schema.Types.ObjectId,ref:'User',required:true},message:{type:String,required:true,trim:true,maxlength:3000},status:{type:String,enum:['pending','reviewed','hidden'],default:'pending',index:true}},{timestamps:true});
export default mongoose.model('Suggestion',schema);
''')
add('backend/src/models/ScratchCard.js', r'''
import mongoose from 'mongoose';
const schema=new mongoose.Schema({category:{type:String,required:true,trim:true,maxlength:120},message:{type:String,required:true,trim:true,maxlength:1000},enabled:{type:Boolean,default:true,index:true},order:{type:Number,default:0}},{timestamps:true});
export default mongoose.model('ScratchCard',schema);
''')
add('backend/src/models/SiteSettings.js', r'''
import mongoose from 'mongoose';
const schema=new mongoose.Schema({key:{type:String,required:true,unique:true},value:{type:mongoose.Schema.Types.Mixed,required:true}},{timestamps:true});
export default mongoose.model('SiteSettings',schema);
''')

add('backend/src/middleware/authenticate.js', r'''
import jwt from 'jsonwebtoken';import User from '../models/User.js';
export async function authenticate(req,res,next){try{const header=req.headers.authorization||'';const token=header.startsWith('Bearer ')?header.slice(7):null;if(!token)return res.status(401).json({message:'Please sign in to continue.'});const payload=jwt.verify(token,process.env.JWT_SECRET);const user=await User.findById(payload.sub).select('email role');if(!user)return res.status(401).json({message:'Account not found. Please sign in again.'});req.user=user;next()}catch{return res.status(401).json({message:'Your session is invalid or expired. Please sign in again.'})}}
''')
add('backend/src/middleware/requireAdmin.js', r'''
export function requireAdmin(req,res,next){if(req.user?.role!=='admin')return res.status(403).json({message:'Administrator access is required.'});next()}
''')
add('backend/src/middleware/errorHandler.js', r'''
export function errorHandler(err,req,res,next){console.error(err);if(res.headersSent)return next(err);res.status(err.status||500).json({message:process.env.NODE_ENV==='production'?'Something went wrong.':err.message||'Internal server error.'})}
''')

add('backend/src/controllers/authController.js', r'''
import bcrypt from 'bcryptjs';import jwt from 'jsonwebtoken';import User from '../models/User.js';
function tokenFor(user){return jwt.sign({sub:user._id.toString()},process.env.JWT_SECRET,{expiresIn:'7d'})}
function publicUser(user){return {id:user._id,email:user.email,role:user.role}}
export async function register(req,res,next){try{let {email,password}=req.body;email=String(email||'').trim().toLowerCase();if(!/^\S+@\S+\.\S+$/.test(email))return res.status(400).json({message:'Enter a valid email address.'});if(typeof password!=='string'||password.length<8)return res.status(400).json({message:'Password must be at least 8 characters.'});if(password.length>128)return res.status(400).json({message:'Password is too long.'});if(await User.exists({email}))return res.status(409).json({message:'An account with this email already exists.'});const user=await User.create({email,passwordHash:await bcrypt.hash(password,12)});res.status(201).json({token:tokenFor(user),user:publicUser(user)})}catch(e){if(e.code===11000)return res.status(409).json({message:'An account with this email already exists.'});next(e)}}
export async function login(req,res,next){try{const email=String(req.body.email||'').trim().toLowerCase();const password=String(req.body.password||'');const user=await User.findOne({email}).select('+passwordHash');if(!user||!(await bcrypt.compare(password,user.passwordHash)))return res.status(401).json({message:'Email or password is incorrect.'});res.json({token:tokenFor(user),user:publicUser(user)})}catch(e){next(e)}}
export async function me(req,res){res.json({user:publicUser(req.user)})}
''')
add('backend/src/controllers/communityController.js', r'''
import CommunityInterest from '../models/CommunityInterest.js';import SiteSettings from '../models/SiteSettings.js';
export async function count(req,res,next){try{const [actual,setting]=await Promise.all([CommunityInterest.countDocuments(),SiteSettings.findOne({key:'communityTarget'})]);const envTarget=Number(process.env.COMMUNITY_TARGET)||21;const target=setting?Number(setting.value):envTarget;res.json({count:actual,target,remaining:Math.max(0,target-actual),milestoneReached:actual>=target})}catch(e){next(e)}}
export async function registerInterest(req,res,next){try{const existing=await CommunityInterest.findOne({user:req.user._id});if(existing)return res.json({message:'Your interest is already registered. Thank you for being part of this.',alreadyRegistered:true});await CommunityInterest.create({user:req.user._id});res.status(201).json({message:'Thank you. Your interest has been registered.',alreadyRegistered:false})}catch(e){if(e.code===11000)return res.json({message:'Your interest is already registered. Thank you for being part of this.',alreadyRegistered:true});next(e)}}
''')
add('backend/src/controllers/commentController.js', r'''
import Comment from '../models/Comment.js';
export async function createComment(req,res,next){try{const message=String(req.body.message||'').trim();if(!message)return res.status(400).json({message:'Please enter a message.'});if(message.length>2000)return res.status(400).json({message:'Message must be 2,000 characters or fewer.'});await Comment.create({user:req.user._id,message});res.status(201).json({message:'Thank you. Your message has been submitted for review.'})}catch(e){next(e)}}
export async function listComments(req,res,next){try{const items=await Comment.find().populate('user','email').sort({createdAt:-1}).limit(500);res.json({items})}catch(e){next(e)}}
export async function moderateComment(req,res,next){try{const status=req.body.status;if(!['pending','reviewed','hidden'].includes(status))return res.status(400).json({message:'Invalid moderation status.'});const item=await Comment.findByIdAndUpdate(req.params.id,{status},{new:true}).populate('user','email');if(!item)return res.status(404).json({message:'Comment not found.'});res.json({item})}catch(e){next(e)}}
''')
add('backend/src/controllers/suggestionController.js', r'''
import Suggestion from '../models/Suggestion.js';
export async function createSuggestion(req,res,next){try{const message=String(req.body.message||'').trim();if(!message)return res.status(400).json({message:'Please enter a suggestion.'});if(message.length>3000)return res.status(400).json({message:'Suggestion must be 3,000 characters or fewer.'});await Suggestion.create({user:req.user._id,message});res.status(201).json({message:'Thank you. Your suggestion has been submitted for review.'})}catch(e){next(e)}}
''')
add('backend/src/controllers/scratchCardController.js', r'''
import ScratchCard from '../models/ScratchCard.js';
export async function publicList(req,res,next){try{const items=await ScratchCard.find({enabled:true}).sort({order:1,createdAt:1}).select('category message order');res.json({items})}catch(e){next(e)}}
export async function adminList(req,res,next){try{const items=await ScratchCard.find().sort({order:1,createdAt:1});res.json({items})}catch(e){next(e)}}
export async function create(req,res,next){try{const category=String(req.body.category||'').trim(),message=String(req.body.message||'').trim();if(!category||!message)return res.status(400).json({message:'Category and message are required.'});const last=await ScratchCard.findOne().sort({order:-1});const item=await ScratchCard.create({category,message,order:(last?.order??-1)+1});res.status(201).json({item})}catch(e){next(e)}}
export async function update(req,res,next){try{const patch={};if(typeof req.body.category==='string')patch.category=req.body.category.trim();if(typeof req.body.message==='string')patch.message=req.body.message.trim();if(typeof req.body.enabled==='boolean')patch.enabled=req.body.enabled;if(Number.isFinite(req.body.order))patch.order=req.body.order;const item=await ScratchCard.findByIdAndUpdate(req.params.id,patch,{new:true,runValidators:true});if(!item)return res.status(404).json({message:'Scratch message not found.'});res.json({item})}catch(e){next(e)}}
export async function remove(req,res,next){try{const item=await ScratchCard.findByIdAndDelete(req.params.id);if(!item)return res.status(404).json({message:'Scratch message not found.'});res.json({message:'Scratch message deleted.'})}catch(e){next(e)}}
''')
add('backend/src/controllers/adminController.js', r'''
import CommunityInterest from '../models/CommunityInterest.js';import Comment from '../models/Comment.js';import Suggestion from '../models/Suggestion.js';import ScratchCard from '../models/ScratchCard.js';import SiteSettings from '../models/SiteSettings.js';import User from '../models/User.js';
export async function dashboard(req,res,next){try{const [count,comments,suggestions,scratchCards,setting]=await Promise.all([CommunityInterest.countDocuments(),Comment.countDocuments(),Suggestion.countDocuments(),ScratchCard.countDocuments(),SiteSettings.findOne({key:'communityTarget'})]);res.json({count,comments,suggestions,scratchCards,target:setting?Number(setting.value):(Number(process.env.COMMUNITY_TARGET)||21)})}catch(e){next(e)}}
export async function participants(req,res,next){try{const items=await CommunityInterest.find().populate('user','email createdAt').sort({createdAt:-1}).limit(2000);res.json({items})}catch(e){next(e)}}
export async function settings(req,res,next){try{const target=Number(req.body.target);if(!Number.isInteger(target)||target<1||target>1000000)return res.status(400).json({message:'Target must be a whole number between 1 and 1,000,000.'});const setting=await SiteSettings.findOneAndUpdate({key:'communityTarget'},{key:'communityTarget',value:target},{new:true,upsert:true});res.json({target:Number(setting.value)})}catch(e){next(e)}}
export async function adminSuggestions(req,res,next){try{const items=await Suggestion.find().populate('user','email').sort({createdAt:-1}).limit(500);res.json({items})}catch(e){next(e)}}
''')

add('backend/src/routes/authRoutes.js', r'''
import {Router} from 'express';import {register,login,me} from '../controllers/authController.js';import {authenticate} from '../middleware/authenticate.js';
const router=Router();router.post('/register',register);router.post('/login',login);router.get('/me',authenticate,me);export default router;
''')
add('backend/src/routes/communityRoutes.js', r'''
import {Router} from 'express';import {count,registerInterest} from '../controllers/communityController.js';import {authenticate} from '../middleware/authenticate.js';
const router=Router();router.get('/count',count);router.post('/interest',authenticate,registerInterest);export default router;
''')
add('backend/src/routes/commentRoutes.js', r'''
import {Router} from 'express';import {createComment,listComments,moderateComment} from '../controllers/commentController.js';import {authenticate} from '../middleware/authenticate.js';import {requireAdmin} from '../middleware/requireAdmin.js';
const router=Router();router.post('/',authenticate,createComment);router.get('/',authenticate,requireAdmin,listComments);router.patch('/:id',authenticate,requireAdmin,moderateComment);export default router;
''')
add('backend/src/routes/suggestionRoutes.js', r'''
import {Router} from 'express';import {createSuggestion} from '../controllers/suggestionController.js';import {authenticate} from '../middleware/authenticate.js';import {requireAdmin} from '../middleware/requireAdmin.js';import {adminSuggestions} from '../controllers/adminController.js';
const router=Router();router.post('/',authenticate,createSuggestion);router.get('/',authenticate,requireAdmin,adminSuggestions);export default router;
''')
add('backend/src/routes/scratchCardRoutes.js', r'''
import {Router} from 'express';import {publicList,adminList,create,update,remove} from '../controllers/scratchCardController.js';import {authenticate} from '../middleware/authenticate.js';import {requireAdmin} from '../middleware/requireAdmin.js';
const router=Router();router.get('/',publicList);router.get('/admin',authenticate,requireAdmin,adminList);router.post('/',authenticate,requireAdmin,create);router.patch('/:id',authenticate,requireAdmin,update);router.delete('/:id',authenticate,requireAdmin,remove);export default router;
''')
add('backend/src/routes/adminRoutes.js', r'''
import {Router} from 'express';import {dashboard,participants,settings} from '../controllers/adminController.js';import {authenticate} from '../middleware/authenticate.js';import {requireAdmin} from '../middleware/requireAdmin.js';import {listComments,moderateComment} from '../controllers/commentController.js';import {adminList,create,update,remove} from '../controllers/scratchCardController.js';
const router=Router();router.use(authenticate,requireAdmin);router.get('/dashboard',dashboard);router.get('/participants',participants);router.put('/settings',settings);router.get('/comments',listComments);router.patch('/comments/:id',moderateComment);router.get('/scratch-cards',adminList);router.post('/scratch-cards',create);router.patch('/scratch-cards/:id',update);router.delete('/scratch-cards/:id',remove);export default router;
''')

add('backend/src/app.js', r'''
import express from 'express';import cors from 'cors';import helmet from 'helmet';import rateLimit from 'express-rate-limit';import authRoutes from './routes/authRoutes.js';import communityRoutes from './routes/communityRoutes.js';import commentRoutes from './routes/commentRoutes.js';import suggestionRoutes from './routes/suggestionRoutes.js';import scratchCardRoutes from './routes/scratchCardRoutes.js';import adminRoutes from './routes/adminRoutes.js';import {errorHandler} from './middleware/errorHandler.js';
const app=express();app.disable('x-powered-by');app.use(helmet());app.use(cors({origin:(process.env.CLIENT_URL||'http://localhost:5173').split(',').map(s=>s.trim()),credentials:false}));app.use(express.json({limit:'32kb'}));app.use('/api/auth',rateLimit({windowMs:15*60*1000,max:30,standardHeaders:true,legacyHeaders:false}),authRoutes);app.use('/api/community',communityRoutes);app.use('/api/comments',commentRoutes);app.use('/api/suggestions',suggestionRoutes);app.use('/api/scratch-cards',scratchCardRoutes);app.use('/api/admin',adminRoutes);app.get('/api/health',(req,res)=>res.json({status:'ok',service:'The Self-Governed Girl API'}));app.use((req,res)=>res.status(404).json({message:'API endpoint not found.'}));app.use(errorHandler);export default app;
''')
add('backend/src/server.js', r'''
import 'dotenv/config';import app from './app.js';import {connectDatabase} from './config/database.js';
const port=Number(process.env.PORT)||5000;
if(!process.env.JWT_SECRET||process.env.JWT_SECRET.length<32){console.error('JWT_SECRET must be set to a unique secret of at least 32 characters in backend/.env');process.exit(1)}
try{await connectDatabase();app.listen(port,'0.0.0.0',()=>console.log(`API listening on http://localhost:${port}`))}catch(error){console.error('Backend startup failed:',error.message);process.exit(1)}
''')
add('backend/src/scripts/seedScratchCards.js', r'''
import 'dotenv/config';import mongoose from 'mongoose';import ScratchCard from '../models/ScratchCard.js';import {scratchCardSeed} from '../../../frontend/src/content/scratchCardSeed.js';
try{await mongoose.connect(process.env.MONGODB_URI);const count=await ScratchCard.countDocuments();if(count){console.log(`Scratch collection already has ${count} records; seed skipped to preserve admin edits.`)}else{await ScratchCard.insertMany(scratchCardSeed.map((x,i)=>({...x,enabled:true,order:i})));console.log(`Inserted ${scratchCardSeed.length} scratch messages.`)}}catch(e){console.error(e.message);process.exitCode=1}finally{await mongoose.disconnect()}
''')
add('backend/src/scripts/createAdmin.js', r'''
import 'dotenv/config';import mongoose from 'mongoose';import bcrypt from 'bcryptjs';import User from '../models/User.js';
try{if(!process.env.MONGODB_URI)throw new Error('MONGODB_URI is missing.');if(!process.env.ADMIN_EMAIL||!process.env.ADMIN_INITIAL_PASSWORD)throw new Error('Set ADMIN_EMAIL and ADMIN_INITIAL_PASSWORD in backend/.env.');if(process.env.ADMIN_INITIAL_PASSWORD.length<12)throw new Error('Use an initial admin password of at least 12 characters.');await mongoose.connect(process.env.MONGODB_URI);const email=process.env.ADMIN_EMAIL.trim().toLowerCase();let user=await User.findOne({email}).select('+passwordHash');if(user){if(user.role!=='admin'){user.role='admin';await user.save()}console.log(`Existing account ${email} promoted to admin. Its password was not changed.`)}else{user=await User.create({email,passwordHash:await bcrypt.hash(process.env.ADMIN_INITIAL_PASSWORD,12),role:'admin'});console.log(`Admin account ${email} created. Change its temporary password before production.`)}}catch(e){console.error(e.message);process.exitCode=1}finally{await mongoose.disconnect()}
''')

# Documentation files
add('docs/PROJECT_STRUCTURE.md', r'''
# Project structure
- `frontend/src/pages` is reserved for splitting page components as the application grows; the current integrated app is in `frontend/src/App.jsx`.
- `frontend/src/content` stores static public copy and assessment content.
- `backend/src/models` defines MongoDB collections.
- `backend/src/controllers` contains API behaviour.
- `backend/src/routes` maps API paths.
- `backend/src/middleware` protects authenticated/admin endpoints.
''')
add('docs/CONTENT_GUIDE.md', r'''
# Content editing
Edit static public copy in `frontend/src/content/`. During development Vite refreshes the site; after deployment rebuild and redeploy the frontend. Scratch-card messages are stored in MongoDB Atlas and managed in Admin Panel → Scratch Manager, so those changes do not require a frontend rebuild. Assessment responses stay in browser state and are not stored remotely.
''')
add('docs/DATABASE_GUIDE.md', r'''
# MongoDB Atlas collections
- `users`: email, password hash, role.
- `communityinterests`: unique user reference; this is the real community count.
- `comments`: user, message, moderation status.
- `suggestions`: user, message, review status.
- `scratchcards`: category, message, enabled state, order.
- `sitesettings`: community milestone target.

Use a least-privilege Atlas database user and allow only the network access needed for development/deployment.
''')
add('docs/DEVELOPMENT_GUIDE.md', r'''
# Development
From the project root: `npm install`, `npm run install:all`, `npm run seed:scratch`, `npm run create:admin`, then `npm run dev`. The generator creates `.env.example` files; copy them to `.env` and fill credentials before starting services.
''')

for rel, content in files.items():
    path = root / rel
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists():
        raise SystemExit(f'Refusing to overwrite existing file: {path}')
    path.write_text(content, encoding='utf-8')

# Copy environment examples to working env files, with placeholders for the user to fill.
for src, dst in [('backend/.env.example','backend/.env'),('frontend/.env.example','frontend/.env')]:
    p=root/dst
    if not p.exists(): p.write_text((root/src).read_text(encoding='utf-8'),encoding='utf-8')

# Create folders used for future split-out page components and public assets.
for folder in [
 'frontend/public/images','frontend/src/assets/images','frontend/src/assets/icons','frontend/src/assets/fonts',
 'frontend/src/components/layout','frontend/src/components/network','frontend/src/components/assessment',
 'frontend/src/components/community','frontend/src/components/reflections','frontend/src/components/common',
 'frontend/src/pages','frontend/src/admin','frontend/src/hooks','frontend/src/services','frontend/src/styles',
 'backend/src/config','backend/src/models','backend/src/controllers','backend/src/routes','backend/src/middleware',
 'backend/src/services','backend/src/utils','backend/src/scripts'
]: (root/folder).mkdir(parents=True,exist_ok=True)
print(f'Created {len(files)} project files under {root}')
print('Created backend/.env and frontend/.env from example templates. Fill the placeholders before running.')
PY

cat <<'NEXT'

Project files created.

NEXT
echo "Installing root and frontend/backend dependencies..."
npm install
npm run install:all

echo ""
echo "NEXT STEPS"
echo "1. Edit backend/.env and enter your MongoDB Atlas URI, a unique JWT_SECRET (32+ characters), and admin password."
echo "2. Edit frontend/.env if your API URL differs from http://localhost:5000/api."
echo "3. After verifying the Atlas URI, run: npm run seed:scratch"
echo "4. Run: npm run create:admin"
echo "5. Run: npm run dev"
echo ""
echo "Frontend: http://localhost:5173"
echo "API health: http://localhost:5000/api/health"
