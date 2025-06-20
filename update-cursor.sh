#!/bin/bash

# URL da API que retorna o JSON com o link de download
API_URL="https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"

# Caminho temporário para salvar o arquivo
TEMP_FILE="/tmp/Cursor.AppImage"

# Caminho de destino
DEST_FILE="/opt/Cursor.AppImage"

# Obter o JSON
echo "Obtendo link real de download..."
JSON_RESPONSE=$(curl -s "$API_URL")

# Extrair o downloadUrl usando jq
DOWNLOAD_URL=$(echo "$JSON_RESPONSE" | jq -r '.downloadUrl')

# Verificar se o downloadUrl foi extraído corretamente
if [ -z "$DOWNLOAD_URL" ] || [ "$DOWNLOAD_URL" == "null" ]; then
  echo "Erro: não foi possível extrair o downloadUrl do JSON."
  exit 1
fi

echo "Link de download encontrado: $DOWNLOAD_URL"

# Fazer o download do AppImage
echo "Baixando Cursor AppImage..."
curl -L "$DOWNLOAD_URL" -o "$TEMP_FILE"

# Verificar se o download foi bem-sucedido
if [ $? -ne 0 ]; then
  echo "Erro ao baixar o AppImage."
  exit 1
fi

# Dar permissão de execução
echo "Dando permissão de execução..."
chmod +x "$TEMP_FILE"

# Mover o arquivo para o destino com sudo
echo "Movendo o AppImage para $DEST_FILE..."
sudo mv "$TEMP_FILE" "$DEST_FILE"

# Confirmar a movimentação
if [ $? -eq 0 ]; then
  echo "Cursor AppImage instalado com sucesso em $DEST_FILE."
else
  echo "Erro ao mover o arquivo para $DEST_FILE."
  exit 1
fi
