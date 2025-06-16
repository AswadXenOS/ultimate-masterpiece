#!/data/data/com.termux/files/usr/bin/bash set -e

🌟 ULTIMATE AUTO-SETUP & DEPLOY SCRIPT FOR aswad-superadmin-ewallet 🌟

Usage: bash setup.sh

1️⃣ Install system packages

echo "[1/12] Updating Termux and installing dependencies..." pkg update -y && pkg upgrade -y pkg install -y git nodejs npm curl termux-api openssh

2️⃣ Generate SSH key if missing

echo "[2/12] Configuring SSH key for GitHub..." if [ ! -f "$HOME/.ssh/id_ed25519" ]; then ssh-keygen -t ed25519 -C "AswadXenOS@users.noreply.github.com" -N "" -f "$HOME/.ssh/id_ed25519" echo " 📋 Copy this public key to GitHub → https://github.com/settings/keys " && cat "$HOME/.ssh/id_ed25519.pub" echo "➡️ Press ENTER once added to GitHub." read -r else echo "🔑 SSH key exists. Skipping generation." fi

3️⃣ Clone or update repository

echo "[3/12] Cloning/updating repository..." cd "$HOME" if [ -d "aswad-superadmin-ewallet" ]; then cd aswad-superadmin-ewallet git reset --hard git pull else git clone git@github.com:AswadXenOS/aswad-superadmin-ewallet.git cd aswad-superadmin-ewallet fi

4️⃣ Create project structure

echo "[4/12] Building project directories..." mkdir -p backend data frontend gpt-cli telegram-bot plugins logs

5️⃣ Generate .env

echo "[5/12] Generating .env file..." cat > .env <<EOF OPENAI_API_KEY=sk-isi-sendiri TELEGRAM_BOT_TOKEN=isi-sendiri MASTER_PASS=aswadultimate PORT=3000 EOF

6️⃣ Backend setup

echo "[6/12] Installing and scaffolding backend..." cd backend npm init -y npm install express cors sqlite3 sqlite bcryptjs qrcode speakeasy fs-extra

cat > index.js <<'BACKEND' const express = require('express'); const cors = require('cors'); const { open } = require('sqlite'); const sqlite3 = require('sqlite3'); const routes = require('./routes');

(async () => { const db = await open({ filename: './data.db', driver: sqlite3.Database }); await db.run( CREATE TABLE IF NOT EXISTS users ( id INTEGER PRIMARY KEY, username TEXT UNIQUE, password TEXT, balance INTEGER DEFAULT 0 ) ); await db.run( CREATE TABLE IF NOT EXISTS logs ( id INTEGER PRIMARY KEY, action TEXT, timestamp DATETIME DEFAULT CURRENT_TIMESTAMP ) );

const app = express(); app.use(cors()); app.use(express.json()); app.use('/api', routes(db));

const port = process.env.PORT || 3000; app.listen(port, () => console.log(✅ Backend running at http://localhost:${port})); })(); BACKEND

cat > routes.js <<'BACKEND_ROUTES' module.exports = (db) => { const router = require('express').Router(); const bcrypt = require('bcryptjs'); const QRCode = require('qrcode'); const speakeasy = require('speakeasy');

router.post('/login', async (req, res) => { const { username, password } = req.body; const user = await db.get('SELECT * FROM users WHERE username = ?', username); if (!user) return res.status(404).json({ error: 'User not found' }); if (!bcrypt.compareSync(password, user.password)) return res.status(403).json({ error: 'Invalid credential' }); res.json({ id: user.id, username: user.username, balance: user.balance }); });

router.get('/users', async (_, res) => { const users = await db.all('SELECT id, username, balance FROM users'); res.json(users); });

router.post('/transfer', async (req, res) => { const { from, to, amount } = req.body; const sender = await db.get('SELECT balance FROM users WHERE username = ?', from); const receiver = await db.get('SELECT balance FROM users WHERE username = ?', to); if (!sender || !receiver || sender.balance < amount) return res.status(400).json({ error: 'Transfer failed' }); await db.run('UPDATE users SET balance = balance - ? WHERE username = ?', amount, from); await db.run('UPDATE users SET balance = balance + ? WHERE username = ?', amount, to); await db.run('INSERT INTO logs (action) VALUES (?)', [${from}->${to} RM${amount}]); res.json({ success: true }); });

router.get('/qr/:username', async (req, res) => { const data = JSON.stringify({ user: req.params.username }); res.json({ qr: await QRCode.toDataURL(data) }); });

router.post('/2fa/secret', (_, res) => { const secret = speakeasy.generateSecret({ length: 20 }); res.json({ secret: secret.ascii }); }); router.post('/2fa/verify', (req, res) => { const { secret, token } = req.body; const valid = speakeasy.totp.verify({ secret, encoding: 'ascii', token }); res.json({ valid }); });

return router; }; BACKEND_ROUTES

cd ..

7️⃣ Frontend setup

echo "[7/12] Installing and scaffolding frontend..." cd frontend npm create vite@latest . -- --template react npm install npm install axios react-router-dom mkdir -p src/components cat > src/theme.js <<'THEME' export const isDarkMode = () => window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches; THEME cd ..

8️⃣ GPT CLI setup

echo "[8/12] Installing GPT CLI..." cd gpt-cli npm init -y npm install readline openai dotenv fs say cat > gpt.js <<'CLI' require('dotenv').config(); const readline = require('readline'); const { Configuration, OpenAIApi } = require('openai'); const fs = require('fs'); const say = require('say'); const rl = readline.createInterface({ input: process.stdin, output: process.stdout }); const ai = new OpenAIApi(new Configuration({ apiKey: process.env.OPENAI_API_KEY })); console.log('🧠 GPT CLI Ready'); rl.on('line', async (inp) => { fs.appendFileSync('history.txt', [USER] ${inp}\n); const res = await ai.createChatCompletion({ model: 'gpt-3.5-turbo', messages: [{ role: 'user', content: inp }] }); const out = res.data.choices[0].message.content.trim(); console.log('GPT:', out); say.speak(out); fs.appendFileSync('history.txt', [BOT]  ${out}\n); }); CLI cd ..

9️⃣ Telegram Bot setup

echo "[9/12] Installing Telegram Bot..." cd telegram-bot npm init -y npm install node-telegram-bot-api dotenv cat > bot.js <<'TG' require('dotenv').config(); const TelegramBot = require('node-telegram-bot-api'); const bot = new TelegramBot(process.env.TELEGRAM_BOT_TOKEN, { polling: true }); bot.onText(//start/, msg => bot.sendMessage(msg.chat.id, '🤖 Bot Active')); bot.on('message', msg => { if (!msg.text.startsWith('/')) bot.sendMessage(msg.chat.id, You said: ${msg.text}); }); TG cd ..

🔟 Plugins, logs, data & wallet

echo "[10/12] Setting up plugins, logs, data & wallet..." mkdir -p plugins logs data

echo "module.exports = d => console.log('Plugin:', d);" > plugins/example.js

echo "[]" > data/users.json node -e "const fs = require('fs'), b = require('bcryptjs'); const u=[{id:1,username:'aswad',password:b.hashSync('aswadultimate',10),role:'superadmin'}]; fs.writeFileSync('data/users.json', JSON.stringify(u,null,2));"

echo '{}' > backend/wallet.json

🔢 Create shortcuts

echo "[11/12] Generating shortcuts..." echo "cd $HOME/aswad-superadmin-ewallet/backend && node index.js" > $HOME/start-backend.sh && chmod +x $HOME/start-backend.sh

echo "cd $HOME/aswad-superadmin-ewallet/frontend && npm run dev" > $HOME/start-frontend.sh && chmod +x $HOME/start-frontend.sh

echo "cd $HOME/aswad-superadmin-ewallet/gpt-cli && node gpt.js" > $HOME/start-gpt.sh && chmod +x $HOME/start-gpt.sh

echo "cd $HOME/aswad-superadmin-ewallet/telegram-bot && node bot.js" > $HOME/start-bot.sh && chmod +x $HOME/start-bot.sh

1️⃣2️⃣ Notification & Git Push

echo "[12/12] Sending notification & pushing to GitHub..." termux-notification --title "SuperAdmin eWallet" --content "Setup Complete!" --priority high

git config --global user.name "Aswad Xenist" git config --global user.email "aswadxenos@users.noreply.github.com" git add . git commit -m "✅ Auto-setup complete" git push -u origin main

Done

clear echo "🎉 Auto-setup finished 100%! Launch with:" echo "  bash ~/start-backend.sh" echo "  bash ~/start-frontend.sh" echo "  bash ~/start-gpt.sh" echo "  bash ~/start-bot.sh" echo "SuperAdmin login: aswad / aswadultimate"
