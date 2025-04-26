# ==========================================
# 🚀 1. Update system
# ==========================================
sudo apt update && sudo apt upgrade -y

# ==========================================
# 📥 2. Install curl, wget, git, build tools
# ==========================================
sudo apt install -y curl wget git build-essential

# ==========================================
# 🔵 3. Install Node.js (LTS) + npm
# ==========================================
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# ==========================================
# ✅ 4. Check Node.js and npm versions
# ==========================================
node -v
npm -v

# ==========================================
# 🛢️ 5. Install MySQL Server
# ==========================================
sudo apt install -y mysql-server

# ==========================================
# 🔒 6. Secure MySQL installation (recommended)
# ==========================================
sudo mysql_secure_installation

# ==========================================
# 🔍 7. Check MySQL service status
# ==========================================
sudo systemctl status mysql

# ==========================================
# 🖥️ 8. Install Visual Studio Code (Official)
# ==========================================
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code

# ==========================================
# 🧩 9. (Optional) Install VSCode Extensions
# ==========================================
code --install-extension dbaeumer.vscode-eslint
code --install-extension esbenp.prettier-vscode
code --install-extension ms-vscode.vscode-typescript-next

# ==========================================
# 🌎 10. (Optional) Install global npm packages
# ==========================================
sudo npm install -g nodemon
sudo npm install -g pm2
sudo npm install -g typescript

# ==========================================
# 🎯 11. Environment partially ready!
# ==========================================
echo "✅ Web Development Environment Ready!"

# ==========================================
# 🏛️ 12. Install Apache2 (optional)
# ==========================================
sudo apt install -y apache2
sudo systemctl enable apache2
sudo systemctl start apache2

# ==========================================
# 🐘 13. Install PHP + common modules
# ==========================================
sudo apt install -y php libapache2-mod-php php-mysql php-cli php-curl php-json php-cgi php-gd php-mbstring php-xml php-zip php-bcmath

# ==========================================
# 🐳 14. Install Docker + Docker Compose
# ==========================================
sudo apt install -y ca-certificates gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Habilitar Docker no boot
sudo systemctl enable docker
sudo systemctl start docker

# Adicionar seu usuário ao grupo Docker (para usar sem sudo)
sudo usermod -aG docker $USER

# ==========================================
# 🍃 15. Install MongoDB (NoSQL database)
# ==========================================
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update
sudo apt install -y mongodb-org
sudo systemctl start mongod
sudo systemctl enable mongod

# ==========================================
# 🐘 16. Install PostgreSQL (alternative SQL database)
# ==========================================
sudo apt install -y postgresql postgresql-contrib

# ==========================================
# 🐍 17. Install Python 3 + Pip
# ==========================================
sudo apt install -y python3 python3-pip

# ==========================================
# ⚡ 18. Install ZSH + Oh-My-Zsh (better terminal)
# ==========================================
sudo apt install -y zsh
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ==========================================
# 🔧 19. Install other useful tools
# ==========================================
sudo apt install -y tmux htop unzip zip nano vim

# ==========================================
# 🧹 20. System Clean up
# ==========================================
sudo apt autoremove -y

# ==========================================
# 🎉 21. Final Message
# ==========================================
echo "✅ Full Web Development Environment is now installed!"
echo "👉 Please restart your machine to apply all changes (especially Docker group)"
