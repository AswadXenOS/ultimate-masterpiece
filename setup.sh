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

