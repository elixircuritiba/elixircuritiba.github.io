#!/bin/bash

# Configurações
PASTA_FOTOS="."  # Pasta atual
ARQUIVO_SAIDA="index.md"
TITULO_PAGINA="Fotos da Elixir Curitiba 2025"

# Verifica se a pasta existe
if [ ! -d "$PASTA_FOTOS" ]; then
    echo "Erro: A pasta '$PASTA_FOTOS' não existe!"
    exit 1
fi

# Função para gerar título a partir do nome do arquivo
gerar_titulo() {
    local arquivo="$1"
    # Remove extensão e substitui _ e - por espaços
    local titulo=$(basename "$arquivo" | sed 's/\.[^.]*$//' | sed 's/[_-]/ /g')
    # Capitaliza primeira letra de cada palavra
    echo "$titulo" | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1'
}

# Cria o arquivo Markdown
echo "# $TITULO_PAGINA" > "$ARQUIVO_SAIDA"
echo "" >> "$ARQUIVO_SAIDA"
echo "- Fotógrafo: [Gustavo Arcoverde](https://www.instagram.com/gusarcoverde.fotografia/)" > "$ARQUIVO_SAIDA"
echo "" >> "$ARQUIVO_SAIDA"

# Contador de fotos
contador=0

# Cria array com todas as imagens
mapfile -t imagens < <(find "$PASTA_FOTOS" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" -o -iname "*.svg" \) | sort)

# Processa cada imagem
for img in "${imagens[@]}"; do
    # Pula se vazio
    [ -z "$img" ] && continue
    
    # Gera título
    titulo=$(gerar_titulo "$img")
    
    # Adiciona ao Markdown
    echo "## $titulo" >> "$ARQUIVO_SAIDA"
    echo "<img src=\"$img\" alt=\"$titulo\" style=\"max-width: 90%; height: auto;\" />" >> "$ARQUIVO_SAIDA"
    echo "" >> "$ARQUIVO_SAIDA"
    
    ((contador++))
done

# Resultado
if [ $contador -eq 0 ]; then
    echo "Nenhuma imagem encontrada em '$PASTA_FOTOS'"
    rm "$ARQUIVO_SAIDA"
    exit 1
else
    echo "✅ Arquivo '$ARQUIVO_SAIDA' criado com sucesso!"
    echo "📸 Total de fotos: $contador"
fi
