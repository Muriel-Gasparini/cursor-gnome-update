#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_message() {
    echo -e "${2}${1}${NC}"
}

# Função principal
main() {
    print_message "=== Setup do Cursor GNOME Update ===" "$BLUE"
    
    # Verificar se está executando do diretório correto
    if [ ! -f "install-cursor.sh" ] || [ ! -f "update-cursor.sh" ]; then
        print_message "Erro: Execute este script no diretório do projeto cursor-gnome-update" "$RED"
        exit 1
    fi
    
    # Obter o diretório atual (absoluto)
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    
    print_message "Diretório do projeto: $SCRIPT_DIR" "$BLUE"
    
    # Dar permissões de execução aos scripts
    print_message "Configurando permissões..." "$BLUE"
    chmod +x "$SCRIPT_DIR/install-cursor.sh"
    chmod +x "$SCRIPT_DIR/update-cursor.sh"
    
    # Criar script wrapper para o comando global
    print_message "Criando comando global 'update-cursor'..." "$BLUE"
    
    # Criar o script wrapper temporário
    cat > /tmp/update-cursor << EOF
#!/bin/bash
# Cursor GNOME Update - Comando Global
# Gerado automaticamente pelo setup.sh

cd "$SCRIPT_DIR"
./install-cursor.sh "\$@"
EOF
    
    # Mover para /usr/local/bin com sudo
    sudo mv /tmp/update-cursor /usr/local/bin/update-cursor
    
    # Dar permissão de execução
    sudo chmod +x /usr/local/bin/update-cursor
    
    if [ $? -eq 0 ]; then
        print_message "✅ Comando 'update-cursor' instalado com sucesso!" "$GREEN"
        print_message "" ""
        print_message "🎯 Agora você pode usar de qualquer lugar:" "$GREEN"
        print_message "   update-cursor" "$BLUE"
        print_message "" ""
        print_message "📋 O que o comando faz:" "$YELLOW"
        print_message "   • Se o Cursor não estiver instalado: instala completamente" "$YELLOW"
        print_message "   • Se o Cursor já estiver instalado: apenas atualiza" "$YELLOW"
        print_message "" ""
        print_message "🔧 O comando está instalado em: /usr/local/bin/update-cursor" "$BLUE"
        print_message "📁 Scripts originais permanecem em: $SCRIPT_DIR" "$BLUE"
    else
        print_message "❌ Erro ao instalar o comando global" "$RED"
        exit 1
    fi
}

# Executar função principal
main "$@" 