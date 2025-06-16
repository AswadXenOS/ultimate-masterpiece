#!/data/data/com.termux/files/usr/bin/bash set -e

🌟 ULTIMATE SETUP SCRIPT FOR ultimate-masterpiece 🌟

echo "🚀 Memulakan pemasangan sistem Ultimate Masterpiece..."

1️⃣ Pasang keperluan sistem

pkg update -y && pkg upgrade -y pkg install -y git nodejs wget curl termux-api

2️⃣ Clone repo GitHub via HTTPS

echo "[2/20] Menyalin repositori..." cd ~ rm -rf ultimate-masterpiece git clone https://github.com/AswadXenOS/ultimate-masterpiece.git cd ultimate-masterpiece

3️⃣ Cipta struktur folder

echo "[3/20] Membina direktori..." mkdir -p backend data/frontend data gpt-cli telegram-bot plugins logs mock-bank-api whatsapp-bot

4️⃣ Cipta .env

echo "[4/20] Menjana fail .env..." cat > .env <<EOF OPENAI_API_KEY=sk-isi-sendiri TELEGRAM_BOT_TOKEN=isi-sendiri MASTER_PASS=aswadultimate PORT=3000 BANK_API_URL=http://localhost:4000/api/bank/transfer EOF

5️⃣ Backend setup

echo "[5/20] Setup backend..." cd backend npm init -y npm install express cors sqlite3 bcryptjs qrcode speakeasy fs-extra

cat > index.js <<'JS' const express = require('express'); const cors = require('cors'); const fs = require('fs-extra'); const initDB = require('./db'); const { loadPlugins } = require('./plugins'); const { generateQR } = require('./qr'); const { verify, generateSecret } = require('./2fa');

(async ()=>{ const db = await initDB(); const app = express(); app.use(cors()); app.use(express.json());

// Load plugins loadPlugins(app, db);

// Default endpoint app.get('/', (req, res)=> res.send('🚀 Backend Active'));

// Start const PORT = process.env.PORT || 3000; app.listen(PORT, ()=> console.log(🚀 Backend running on http://localhost:${PORT})); })(); JS

db

cat > db.js <<'JS' const sqlite3 = require('sqlite3'); const { open } = require('sqlite'); module.exports = async ()=> open({ filename: './data.db', driver: sqlite3.Database }); JS

plugins loader\mkdir -p plugins

cat > plugins/index.js <<'JS' const fs = require('fs'); const path = require('path'); function loadPlugins(app, db) { const dir = __dirname; fs.readdirSync(dir).filter(f=> f.endsWith('.js') && f!=='index.js') .forEach(f=> require(path.join(dir,f))(app, db)); } module.exports = { loadPlugins }; JS

sample plugin

cat > plugins/sample.js <<'JS' module.exports = (app, db)=>{ app.get('/api/plugin/sample',(req,res)=> res.json({status:'active'})); }; JS

qr

cat > qr.js <<'JS' const QRCode = require('qrcode'); async function generateQR(data){ return QRCode.toDataURL(data); } module.exports = { generateQR }; JS

2fa

cat > 2fa.js <<'JS' const speakeasy = require('speakeasy'); module.exports = { generateSecret: ()=> speakeasy.generateSecret({length:20}), verify: (secret, token)=> speakeasy.totp.verify({ secret, encoding:'ascii', token }) }; JS

cd ..

6️⃣ Mock Bank API

echo "[6/20] Setup mock-bank-api..." cd mock-bank-api npm init -y npm install express cat > server.js <<'JS' const express = require('express'); const app = express(); app.use(express.json()); app.post('/api/bank/transfer',(req,res)=>{ const { from,to,amount }= req.body; res.json({status:'success',from,to,amount,trxId:'MOCK-'+Date.now()}); }); app.listen(4000, ()=> console.log('🏦 Mock Bank API running on http://localhost:4000')); JS cd ..

7️⃣ WhatsApp Bot placeholder

echo "[7/20] Setup WhatsApp bot..." cd whatsapp-bot npm init -y cat > index.js <<'JS' console.log('📲 WhatsApp Bot running (dummy)'); JS cd ..

8️⃣ Frontend setup

echo "[8/20] Setup frontend..." cd frontend npm create vite@latest . -- --template react npm install npm install axios react-router-dom mkdir -p src/components cat > src/theme.js <<'JS' export const isDarkMode = ()=> window.matchMedia('(prefers-color-scheme: dark)').matches; JS cd ..

9️⃣ GPT CLI

echo "[9/20] Setup GPT CLI..." cd gpt-cli npm init -y npm install readline openai dotenv fs say cat > gpt.js <<'JS' require('dotenv').config(); const rl=require('readline').createInterface({input:process.stdin,output:process.stdout}); const {OpenAIApi,Configuration}=require('openai'); const fs=require('fs');const say=require('say'); const openai=new OpenAIApi(new Configuration({apiKey:process.env.OPENAI_API_KEY})); console.log('🧠 GPT CLI Ready'); rl.on('line',async input=>{ fs.appendFileSync('history.txt',[USER] ${input}\n); const res=await openai.createChatCompletion({model:'gpt-3.5-turbo',messages:[{role:'user',content:input}]}); const msg=res.data.choices[0].message.content.trim(); console.log('GPT:',msg);say.speak(msg); fs.appendFileSync('history.txt',[BOT] ${msg}\n); }); JS cd ..

10️⃣ Telegram Bot

echo "[10/20] Setup Telegram Bot..." cd telegram-bot npm init -y npm install node-telegram-bot-api dotenv cat > bot.js <<'JS' require('dotenv').config(); const TelegramBot=require('node-telegram-bot-api'); const bot=new TelegramBot(process.env.TELEGRAM_BOT_TOKEN,{polling:true}); bot.onText(//start/,(m)=>bot.sendMessage(m.chat.id,'🤖 Bot Active')); bot.on('message',msg=>{if(!msg.text.startsWith('/'))bot.sendMessage(msg.chat.id,You said: ${msg.text})}); JS cd ..

11️⃣ Data + SuperAdmin

echo "[11/20] Creating users.json..." mkdir -p data node -e "const fs=require('fs'),b=require('bcryptjs');fs.writeFileSync('data/users.json',JSON.stringify([{id:1,name:'Aswad Xenist',username:'aswad',password:b.hashSync('aswadultimate',10),role:'superadmin'}],null,2));"

12️⃣ Wallet file

echo "[12/20] Initializing wallet..." echo '{}'>backend/wallet.json

13️⃣ Shortcuts

echo "[13/20] Creating shortcuts..." echo "cd /start-backend.sh && chmod +x ~/start-backend.sh echo "cd /start-frontend.sh && chmod +x ~/start-frontend.sh echo "cd /start-gpt.sh && chmod +x ~/start-gpt.sh

14️⃣ Notification

echo "[14/20] Sending notification..." termux-notification --title "Setup Complete" --content "Ultimate Masterpiece siap!" --priority high

15️⃣ Auto Git Push

echo "[15/20] Committing & pushing..." git config --global user.name "Aswad Xenist" git config --global user.email "aswad@xenos.com" git add . git commit -m "✅ Auto-setup full run" || true git push -u origin main

16️⃣ Final Info

clear echo "🎉 Semua siap 100%!" echo "🧠 GPT CLI: bash ~/start-gpt.sh" echo "📦 Backend: bash ~/start-backend.sh" echo "🌐 Frontend: bash ~/start-frontend.sh" echo "🔐 login aswad/aswadultimate" echo "📲 Telegram: set TOKEN in .env then bash ~/ultimate-masterpiece/telegram-bot/bot.js" echo "🧾 Logs: logs/audit.log" echo "🎉 Enjoy!"

#!/data/data/com.termux/files/usr/bin/bash
set -e

# 🌟 ULTIMATE SETUP & AUTO-PUSH SCRIPT FOR aswad-superadmin-ewallet 🌟
# Run: bash setup.sh

echo "🚀 Memulakan Auto-Setup Ultimate SuperAdmin eWallet..."

# 1️⃣ Pasang keperluan sistem
echo "[1/20] Installing system packages..."
pkg update -y && pkg upgrade -y
pkg install -y git nodejs npm curl termux-api openssh

# 2️⃣ Gen SSH key jika tiada
echo "[2/20] Setting up SSH key for GitHub..."
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "AswadXenOS@users.noreply.github.com" -N "" -f ~/.ssh/id_ed25519
  echo "📋 Please add this public key to GitHub:"
  cat ~/.ssh/id_ed25519.pub
  read -rp "Press ENTER once added..."
else
  echo "🔑 SSH key already exists. Skipping."
fi

# 3️⃣ Clone or update repo
echo "[3/20] Cloning/updating repository..."
cd ~
if [ -d aswad-superadmin-ewallet ]; then
  cd aswad-superadmin-ewallet && git reset --hard && git pull
else
  git clone git@github.com:AswadXenOS/aswad-superadmin-ewallet.git
  cd aswad-superadmin-ewallet
fi

# 4️⃣ Create directory structure
echo "[4/20] Creating folder structure..."
mkdir -p backend data frontend gpt-cli telegram-bot plugins logs

# 5️⃣ Generate .env
echo "[5/20] Generating .env file..."
cat > .env <<EOF
OPENAI_API_KEY=sk-isi-sendiri
TELEGRAM_BOT_TOKEN=isi-sendiri
MASTER_PASS=aswadultimate
PORT=3000
EOF

# 6️⃣ Setup Backend
echo "[6/20] Installing backend dependencies & scaffolding..."
cd backend
npm init -y
npm install express cors sqlite3 sqlite bcryptjs qrcode speakeasy fs-extra

# backend/index.js
echo "[6.1/20] Writing backend/index.js..."
cat > index.js <<'JS'
const express = require('express');
const cors = require('cors');
const { open } = require('sqlite');
const sqlite3 = require('sqlite3');
const routesFactory = require('./routes');

;(async () => {
  const db = await open({ filename: './data.db', driver: sqlite3.Database });
  await db.run(`CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    username TEXT UNIQUE,
    password TEXT,
    balance INTEGER DEFAULT 0
  )`);
  await db.run(`CREATE TABLE IF NOT EXISTS logs (
    id INTEGER PRIMARY KEY,
    action TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
  )`);

  const app = express();
  app.use(cors());
  app.use(express.json());
  app.use('/api', routesFactory(db));

  const port = process.env.PORT || 3000;
  app.listen(port, () => console.log(`✅ Backend listening on port ${port}`));
})();
JS

# backend/routes.js
cat > routes.js <<'JS'
module.exports = (db) => {
  const { Router } = require('express');
  const bcrypt = require('bcryptjs');
  const speakeasy = require('speakeasy');
  const QRCode = require('qrcode');
  const router = Router();

  // Login
  router.post('/login', async (req, res) => {
    const { username, password } = req.body;
    const user = await db.get('SELECT * FROM users WHERE username=?', username);
    if (!user) return res.status(404).json({ error: 'User not found' });
    if (!bcrypt.compareSync(password, user.password)) return res.status(403).json({ error: 'Invalid password' });
    res.json({ id: user.id, username: user.username, balance: user.balance });
  });

  // List users
  router.get('/users', async (_, res) => {
    const users = await db.all('SELECT id, username, balance FROM users');
    res.json(users);
  });

  // Transfer funds
  router.post('/transfer', async (req, res) => {
    const { from, to, amount } = req.body;
    const sender = await db.get('SELECT balance FROM users WHERE username=?', from);
    const receiver = await db.get('SELECT balance FROM users WHERE username=?', to);
    if (!sender || !receiver || sender.balance < amount) return res.status(400).json({ error: 'Transfer failed' });
    await db.run('UPDATE users SET balance=balance-? WHERE username=?', amount, from);
    await db.run('UPDATE users SET balance=balance+? WHERE username=?', amount, to);
    await db.run('INSERT INTO logs(action) VALUES(?)', [`${from} -> ${to} RM${amount}`]);
    res.json({ success: true });
  });

  // Generate QR
  router.get('/qr/:username', async (req, res) => {
    const data = JSON.stringify({ user: req.params.username });
    const url = await QRCode.toDataURL(data);
    res.json({ qr: url });
  });

  // 2FA
  router.post('/2fa/secret', (_, res) => {
    res.json({ secret: speakeasy.generateSecret({ length: 20 }).ascii });
  });
  router.post('/2fa/verify', (req, res) => {
    const { secret, token } = req.body;
    res.json({ valid: speakeasy.totp.verify({ secret, encoding: 'ascii', token }) });
  });

  return router;
};
JS

cd ..

# 7️⃣ Setup Frontend
echo "[7/20] Installing frontend..."
cd frontend
npm create vite@latest . -- --template react
npm install
npm install axios react-router-dom
mkdir -p src/components
cat > src/theme.js <<'JS'
export const isDarkMode = () =>
  window.matchMedia('(prefers-color-scheme: dark)').matches;
JS
cd ..

# 8️⃣ Setup GPT CLI
echo "[8/20] Installing GPT CLI..."
cd gpt-cli
npm init -y
npm install readline openai dotenv fs say
cat > gpt.js <<'JS'
require('dotenv').config();
const rl = require('readline').createInterface({ input: process.stdin, output: process.stdout });
const { Configuration, OpenAIApi } = require('openai');
const fs = require('fs');
const say = require('say');
const openai = new OpenAIApi(new Configuration({ apiKey: process.env.OPENAI_API_KEY }));

console.log('🧠 GPT CLI ready');
function logHistory(role, text) { fs.appendFileSync('history.txt', `[${role}] ${text}\n`); }
rl.on('line', async (line) => {
  logHistory('USER', line);
  const res = await openai.createChatCompletion({ model: 'gpt-3.5-turbo', messages: [{ role: 'user', content: line }] });
  const msg = res.data.choices[0].message.content;
  console.log('GPT:', msg);
  say.speak(msg);
  logHistory('BOT', msg);
});
JS
cd ..

# 9️⃣ Setup Telegram Bot
echo "[9/20] Installing Telegram bot..."
cd telegram-bot
npm init -y
npm install node-telegram-bot-api dotenv
cat > bot.js <<'JS'
require('dotenv').config();
const TelegramBot = require('node-telegram-bot-api');
const bot = new TelegramBot(process.env.TELEGRAM_BOT_TOKEN, { polling: true });
bot.onText(/\/start/, (msg) => bot.sendMessage(msg.chat.id, '🤖 Bot Active'));
bot.on('message', (msg) => { if (!msg.text.startsWith('/')) bot.sendMessage(msg.chat.id, `You said: ${msg.text}`); });
JS
cd ..

# 🔟 Create Plugins, Logs, Data, Wallet
echo "[10/20] Creating plugins, logs, data, wallet..."
mkdir -p plugins logs data

touch logs/audit.log

# example plugin
cat > plugins/example.js <<'JS'
module.exports = (data) => console.log('Plugin called with', data);
JS

# superadmin user
node -e "const fs=require('fs'),b=require('bcryptjs');fs.writeFileSync('data/users.json', JSON.stringify([{id:1,username:'aswad',password:b.hashSync('aswadultimate',10),role:'superadmin'}],null,2));"

echo '{}' > backend/wallet.json

# 1️⃣1️⃣ Shortcuts
echo "[11/20] Generating shortcuts..."
echo "cd ~/aswad-superadmin-ewallet/backend && node index.js" > ~/start-backend.sh && chmod +x ~/start-backend.sh
echo "cd ~/aswad-superadmin-ewallet/frontend && npm run dev" > ~/start-front.sh && chmod +x ~/start-front.sh
echo "cd ~/aswad-superadmin-ewallet/gpt-cli && node gpt.js" > ~/start-gpt.sh && chmod +x ~/start-gpt.sh
echo "cd ~/aswad-superadmin-ewallet/telegram-bot && node bot.js" > ~/start-bot.sh && chmod +x ~/start-bot.sh
echo "node ~/aswad-superadmin-ewallet/plugins/example.js '{\"test\":true}'" > ~/start-plugin.sh && chmod +x ~/start-plugin.sh

# 1️⃣2️⃣ Notification & Git Push
echo "[12/20] Sending notification & pushing to GitHub..."
termux-notification --title "SuperAdmin eWallet" --content "Setup Complete!" --priority high

git config --global user.name "Aswad Xenist"
git config --global user.email "aswadxenist@example.com"
git add .
git commit -m "✅ Auto-setup complete"
git push -u origin main

# ✅ Done
clear
echo "🎉 Auto-setup finished 100%!"
echo "Run backend: bash ~/start-backend.sh"
echo "Run frontend: bash ~/start-front.sh"
echo "Run GPT CLI: bash ~/start-gpt.sh"
echo "Run bot: bash ~/start-bot.sh"
echo "Test plugin: bash ~/start-plugin.sh"
echo "SuperAdmin login: aswad / aswadultimate"

