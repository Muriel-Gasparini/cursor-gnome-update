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

# Verificar se o Cursor já está instalado
check_cursor_installed() {
    if [ -f "/opt/Cursor.AppImage" ] && [ -f "$HOME/.local/share/icons/cursor-icon.jpg" ]; then
        return 0  # Instalado
    else
        return 1  # Não instalado
    fi
}

# Função para instalar o ícone
install_icon() {
    print_message "Instalando ícone do Cursor..." "$BLUE"
    
    # Criar diretório de ícones se não existir
    mkdir -p "$HOME/.local/share/icons"
    
    # Copiar o ícone
    cp "cursor-icon.jpg" "$HOME/.local/share/icons/cursor-icon.jpg"
    
    if [ $? -eq 0 ]; then
        print_message "Ícone instalado com sucesso!" "$GREEN"
    else
        print_message "Erro ao instalar o ícone." "$RED"
        exit 1
    fi
}

# Função para criar o arquivo .desktop
create_desktop_file() {
    print_message "Criando arquivo .desktop..." "$BLUE"
    
    # Criar diretório de aplicações se não existir
    mkdir -p "$HOME/.local/share/applications"
    
    # Substituir a variável {{HOME_DIR}} pelo diretório home atual
    sed "s|{{HOME_DIR}}|$HOME|g" "Cursor.template.desktop" > "$HOME/.local/share/applications/Cursor.desktop"
    
    # Dar permissão de execução ao arquivo .desktop
    chmod +x "$HOME/.local/share/applications/Cursor.desktop"
    
    if [ $? -eq 0 ]; then
        print_message "Arquivo .desktop criado com sucesso!" "$GREEN"
    else
        print_message "Erro ao criar o arquivo .desktop." "$RED"
        exit 1
    fi
}

# Função para atualizar o banco de dados de aplicações do desktop
update_desktop_database() {
    print_message "Atualizando banco de dados de aplicações..." "$BLUE"
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
    print_message "Banco de dados atualizado!" "$GREEN"
}

# Função para desinstalar
uninstall() {
    print_message "=== Desinstalação Completa do Cursor ===" "$BLUE"
    
    print_message "Removendo Cursor AppImage..." "$BLUE"
    sudo rm -f /opt/Cursor.AppImage
    
    print_message "Removendo arquivo .desktop..." "$BLUE"
    rm -f "$HOME/.local/share/applications/Cursor.desktop"
    
    print_message "Removendo ícone..." "$BLUE"
    rm -f "$HOME/.local/share/icons/cursor-icon.jpg"
    
    print_message "Removendo comando global 'update-cursor'..." "$BLUE"
    sudo rm -f /usr/local/bin/update-cursor
    
    print_message "Removendo arquivos temporários..." "$BLUE"
    rm -rf /tmp/cursor-gnome-update-install
    
    print_message "Atualizando banco de dados de aplicações..." "$BLUE"
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null
    
    print_message "✅ Cursor completamente desinstalado!" "$GREEN"
    print_message "🗑️ Todos os arquivos e configurações foram removidos." "$YELLOW"
}

# Função para mostrar ajuda
show_help() {
    print_message "=== Cursor GNOME Update ===" "$BLUE"
    print_message "" ""
    print_message "Uso:" "$YELLOW"
    print_message "  update-cursor                # Instalar/atualizar Cursor" "$GREEN"
    print_message "  update-cursor --uninstall    # Desinstalar completamente" "$GREEN"
    print_message "  update-cursor --help         # Mostrar esta ajuda" "$GREEN"
    print_message "" ""
    print_message "Descrição:" "$YELLOW"
    print_message "  • Primeira execução: Instala o Cursor completamente" "$BLUE"
    print_message "  • Próximas execuções: Apenas atualiza para versão mais recente" "$BLUE"
    print_message "  • Integração GNOME: Ícone + menu automaticamente" "$BLUE"
}

# Função principal
main() {
    # Verificar opções
    case "${1:-}" in
        --uninstall)
            uninstall
            exit 0
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        "")
            # Continuar com instalação normal
            ;;
        *)
            print_message "❌ Opção inválida: $1" "$RED"
            print_message "Use 'update-cursor --help' para ver as opções disponíveis" "$YELLOW"
            exit 1
            ;;
    esac
    
    print_message "=== Instalador do Cursor IDE para GNOME ===" "$BLUE"
    
    # Verificar se o script está sendo executado do diretório correto
    if [ ! -f "Cursor.template.desktop" ] || [ ! -f "cursor-icon.jpg" ] || [ ! -f "update-cursor.sh" ]; then
        print_message "Erro: Arquivos necessários não encontrados no diretório atual." "$RED"
        print_message "Certifique-se de executar o script no diretório que contém:" "$YELLOW"
        print_message "- Cursor.template.desktop" "$YELLOW"
        print_message "- cursor-icon.jpg" "$YELLOW"
        print_message "- update-cursor.sh" "$YELLOW"
        exit 1
    fi
    
    # Verificar se o Cursor já está instalado
    if check_cursor_installed; then
        print_message "Cursor já está instalado. Executando apenas atualização..." "$YELLOW"
        ./update-cursor.sh
    else
        print_message "Cursor não encontrado. Iniciando instalação completa..." "$YELLOW"
        
        # Executar o script de update para baixar o AppImage
        print_message "Baixando Cursor AppImage..." "$BLUE"
        ./update-cursor.sh
        
        if [ $? -ne 0 ]; then
            print_message "Erro durante o download do Cursor." "$RED"
            exit 1
        fi
        
        # Instalar o ícone
        install_icon
        
        # Criar arquivo .desktop
        create_desktop_file
        
        # Atualizar banco de dados de aplicações
        update_desktop_database
        
        print_message "=== Instalação completa do Cursor concluída! ===" "$GREEN"
        print_message "O Cursor IDE agora está disponível no menu de aplicações do GNOME." "$GREEN"
        print_message "Você pode iniciá-lo procurando por 'Cursor IDE' no menu ou executando:" "$BLUE"
        print_message "/opt/Cursor.AppImage" "$BLUE"
    fi
}

# Executar função principal
main "$@"
