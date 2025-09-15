#!/bin/bash
# Script final e robusto para corrigir --fill-color do swww (Waypaper compatível)
# Seguro, automático e pronto para distribuição

set -e

SWWW_BIN="/usr/bin/swww"
ORIG_SWWW="/usr/bin/swww.real"

# 1️⃣ Garantir que swww original existe
if [ ! -f "$ORIG_SWWW" ]; then
    echo "[*] Criando backup seguro do swww original em $ORIG_SWWW"
    sudo cp "$SWWW_BIN" "$ORIG_SWWW"
fi

# 2️⃣ Instalar wrapper funcional
echo "[*] Instalando wrapper seguro do swww..."
sudo tee "$SWWW_BIN" > /dev/null <<'EOF'
#!/bin/bash
# Wrapper seguro para corrigir cores #RRGGBB ou #RRGGBBAA

ORIG_SWWW="/usr/bin/swww.real"

# Verifica se o binário original existe
if [ ! -f "$ORIG_SWWW" ]; then
    echo "[❌] swww original não encontrado em $ORIG_SWWW!"
    exit 1
fi

# Corrige cores passadas com #
args=()
for arg in "$@"; do
    if [[ "$arg" =~ ^#([0-9a-fA-F]{6}|[0-9a-fA-F]{8})$ ]]; then
        args+=("${arg#\#}")
    else
        args+=("$arg")
    fi
done

# Executa o swww original
exec "$ORIG_SWWW" "${args[@]}"
EOF

# 3️⃣ Tornar executável
sudo chmod +x "$SWWW_BIN"

# 4️⃣ Informações finais
echo "[✅] Wrapper robusto instalado com sucesso!"
echo "[⚠️] Para restaurar o swww original, use:"
echo "sudo cp $ORIG_SWWW $SWWW_BIN"
