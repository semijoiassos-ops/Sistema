<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>EloHub — Operações em Semijoias</title>
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <!-- Biblioteca Chart.js para os Gráficos Individuais e Gerais -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  
  <style>
    :root {
      --bg-main: #F0F4F8;
      --card-bg: rgba(255, 255, 255, 0.94);
      --header-bg: #0F172A;
      --primary-blue: #2563EB;
      --primary-blue-hover: #1D4ED8;
      --accent-cyan: #06B6D4;
      --green-val: #059669;
      --green-hover: #047857;
      --orange-accent: #EA580C;
      --orange-hover: #C2410C;
      --purple-accent: #7C3AED;
      --red-danger: #EF4444;
      --text-dark: #1E293B;
      --text-muted: #64748B;
      --border-color: #E2E8F0;
      --glass-shadow: 0 10px 30px -5px rgba(15, 23, 42, 0.08), 0 4px 12px -2px rgba(15, 23, 42, 0.04);
      --glow-blue: 0 0 20px rgba(37, 99, 235, 0.25);
    }

    * { box-sizing: border-box; font-family: 'Plus Jakarta Sans', sans-serif; transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1); }
    body { background: linear-gradient(135deg, #F8FAFC 0%, #E2E8F0 100%); color: var(--text-dark); margin: 0; padding: 16px; min-height: 100vh; }

    .app-header {
      background: linear-gradient(135deg, #0F172A 0%, #1E293B 100%);
      color: #FFFFFF;
      padding: 20px 24px;
      border-radius: 20px;
      box-shadow: 0 12px 32px rgba(15, 23, 42, 0.25);
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 24px;
      border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .brand-title { margin: 0; font-size: 1.6rem; font-weight: 800; letter-spacing: -0.02em; background: linear-gradient(90deg, #FFFFFF, #93C5FD); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }

    .card-panel {
      background: var(--card-bg);
      backdrop-filter: blur(12px);
      border-radius: 20px;
      padding: 24px;
      border: 1px solid rgba(255, 255, 255, 0.8);
      box-shadow: var(--glass-shadow);
      margin-bottom: 24px;
    }

    .cards-grid-amplos { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 16px; }

    .coluna-etapa-lotes {
      background: rgba(255, 255, 255, 0.75);
      border-radius: 16px;
      padding: 16px;
      border: 1px solid var(--border-color);
      box-shadow: 0 4px 12px rgba(0,0,0,0.02);
    }
    .coluna-etapa-lotes h4 { margin-top: 0; font-size: 0.95rem; font-weight: 700; border-bottom: 2px solid currentColor; padding-bottom: 8px; }

    .card-ampli-item {
      background: #FFFFFF;
      border-radius: 14px;
      padding: 16px;
      margin-bottom: 12px;
      border: 1px solid var(--border-color);
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);
      cursor: pointer;
      position: relative;
      overflow: hidden;
      user-select: none;
    }
    .card-ampli-item:hover {
      transform: translateY(-3px) scale(1.01);
      box-shadow: var(--glow-blue);
      border-color: var(--primary-blue);
    }

    .btn-main {
      width: 100%;
      padding: 12px 18px;
      border: none;
      border-radius: 12px;
      background: var(--primary-blue);
      color: #FFFFFF;
      font-weight: 700;
      font-size: 0.88rem;
      cursor: pointer;
      box-shadow: 0 4px 14px rgba(37, 99, 235, 0.3);
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
    }
    .btn-main:hover { background: var(--primary-blue-hover); transform: translateY(-1px); box-shadow: 0 6px 20px rgba(37, 99, 235, 0.4); }
    .btn-green { background: var(--green-val); box-shadow: 0 4px 14px rgba(5, 150, 105, 0.3); }
    .btn-green:hover { background: var(--green-hover); box-shadow: 0 6px 20px rgba(5, 150, 105, 0.4); }
    .btn-orange { background: var(--orange-accent); box-shadow: 0 4px 14px rgba(234, 88, 12, 0.3); }
    .btn-orange:hover { background: var(--orange-hover); box-shadow: 0 6px 20px rgba(234, 88, 12, 0.4); }
    .btn-danger { background: var(--red-danger); box-shadow: 0 4px 14px rgba(239, 68, 68, 0.3); }
    .btn-danger:hover { background: #DC2626; box-shadow: 0 6px 20px rgba(239, 68, 68, 0.4); }

    .form-control {
      width: 100%;
      padding: 12px 16px;
      border-radius: 12px;
      border: 1px solid var(--border-color);
      background: #FFFFFF;
      margin-bottom: 12px;
      font-size: 0.9rem;
      outline: none;
    }
    .form-control:focus { border-color: var(--primary-blue); box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15); }

    .nav-tabs-bar { display: flex; gap: 8px; background: rgba(226, 232, 240, 0.6); padding: 6px; border-radius: 14px; margin-bottom: 20px; overflow-x: auto; }
    .btn-pag-dir, .btn-pag-op, .profile-tab-btn {
      flex: 1; padding: 10px 16px; border: none; border-radius: 10px; background: transparent; font-weight: 600; font-size: 0.85rem; color: var(--text-muted); cursor: pointer; white-space: nowrap; text-align: center; position: relative;
    }
    .btn-pag-dir.active, .btn-pag-op.active, .profile-tab-btn.active {
      background: #FFFFFF; color: var(--header-bg); font-weight: 700; box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }

    .badge-msg-alert {
      background: #EF4444; color: #FFFFFF; font-size: 0.72rem; font-weight: 800; border-radius: 12px; padding: 2px 7px; margin-left: 6px; display: inline-block; animation: pulse 1.8s infinite;
    }
    @keyframes pulse { 0% { transform: scale(1); } 50% { transform: scale(1.15); } 100% { transform: scale(1); } }

    .badge-status { display: inline-block; padding: 4px 10px; border-radius: 20px; font-size: 0.72rem; font-weight: 800; letter-spacing: 0.03em; text-transform: uppercase; }
    .badge-andamento { background: #E0F2FE; color: #0369A1; border: 1px solid #BAE6FD; }
    .badge-espera { background: #FEF3C7; color: #B45309; border: 1px solid #FDE68A; }
    .badge-concluido { background: #D1FAE5; color: #065F46; border: 1px solid #A7F3D0; }

    .cal-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 6px; margin-top: 10px; }
    .cal-day-header { font-weight: 700; font-size: 0.75rem; text-align: center; color: var(--text-muted); padding: 4px; }
    .cal-day {
      background: #FFFFFF; border-radius: 12px; padding: 10px 4px; text-align: center; border: 1px solid var(--border-color); font-size: 0.85rem; cursor: pointer; min-height: 52px; display: flex; flex-direction: column; justify-content: center; align-items: center;
    }
    .cal-day.disponivel:hover { border-color: var(--green-val); background: #ECFDF5; }
    .cal-day.selected { border: 2px solid var(--green-val); background: #D1FAE5; box-shadow: 0 0 12px rgba(5, 150, 105, 0.3); }
    .cal-status-tag { font-size: 0.65rem; font-weight: 700; display: block; margin-top: 2px; }

    .historico-setores-box { background: #F8FAFC; border: 1px solid var(--border-color); border-radius: 14px; padding: 14px; margin-top: 14px; }
    .item-setor-hist { background: #FFFFFF; border: 1px solid #E2E8F0; padding: 10px 14px; border-radius: 10px; margin-bottom: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.02); }
    .item-setor-hist .stamp-time { font-size: 0.75rem; color: var(--text-muted); display: block; margin-top: 4px; font-weight: 600; }
    .item-setor-hist .stamp-operator { font-size: 0.73rem; color: var(--primary-blue); font-weight: 700; margin-top: 2px; display: block; }

    .modal-overlay { position: fixed; top: 0; left: 0; width: 100vw; height: 100vh; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(6px); display: none; justify-content: center; align-items: center; z-index: 9999; padding: 16px; }
    .modal-card { background: #FFFFFF; width: 100%; max-width: 650px; max-height: 90vh; overflow-y: auto; border-radius: 20px; padding: 24px; box-shadow: 0 20px 50px rgba(0,0,0,0.2); border: 1px solid rgba(255,255,255,0.8); }

    .tabela-sos { width: 100%; border-collapse: collapse; margin-top: 10px; }
    .tabela-sos th, .tabela-sos td { padding: 10px; border-bottom: 1px solid var(--border-color); text-align: left; font-size: 0.85rem; }
    .tabela-sos th { background: #F8FAFC; color: var(--text-muted); font-weight: 700; }
  </style>
</head>
<body><!-- CABEÇALHO GLOBAL -->
  <div class="app-header">
    <div>
      <h1 class="brand-title">Clube S.O.S.</h1>
      <span style="font-size:0.75rem; color:#94A3B8; font-weight:600; letter-spacing:0.05em;">OPERAÇÕES EM SEMIJOIAS</span>
    </div>
    <div id="userBadgeArea" style="display:none; text-align:right;">
      <span id="nomeUsuarioBadge" style="font-weight:700; font-size:0.9rem; display:block;"></span>
      <span id="statusSync" style="font-size:0.72rem; color:#38BDF8; font-weight:600;">☁️ Nuvem Conectada</span> | 
      <a href="javascript:void(0)" onclick="fazerLogout()" style="color:#FCA5A5; text-decoration:none; font-size:0.75rem; font-weight:700;">SAIR</a>
    </div>
  </div>

  <!-- TELA DE LOGIN UNIFICADA -->
  <div id="loginScreen" class="card-panel" style="max-width:420px; margin:40px auto; text-align:center;">
    <h2 style="margin-top:0; color:var(--header-bg); font-weight:800;">Acesso ao Sistema</h2>
    <p style="font-size:0.82rem; color:var(--text-muted); margin-bottom:20px;">Seleção de Perfil e Credenciais</p>
    
    <div class="nav-tabs-bar">
      <button id="tabCliente" class="profile-tab-btn active" onclick="selecionarPerfilAcesso('cliente')">Cliente</button>
      <button id="tabEquipe" class="profile-tab-btn" onclick="selecionarPerfilAcesso('equipe')">Equipe</button>
      <button id="tabDiretoria" class="profile-tab-btn" onclick="selecionarPerfilAcesso('diretoria')">Diretoria</button>
    </div>

    <form onsubmit="autenticarUsuario(event)">
      <select id="selectUsuarioLogin" class="form-control" required></select>
      <input type="password" id="inputSenha" class="form-control" placeholder="Sua senha..." required>
      <button type="submit" class="btn-main" style="margin-top:10px;">ENTRAR NO SISTEMA ➔</button>
    </form>
  </div>

  <!-- PAINEL CLIENTE -->
  <div id="painelCliente" style="display:none;">
    <div class="card-panel">
      <h2 id="tituloClientePainel" style="margin-top:0; color:var(--header-bg);">💎 PAINEL DO CLIENTE</h2>
      
      <div class="nav-tabs-bar">
        <button id="btnNavCliLotes" class="btn-pag-op active" onclick="navegarPaginaCliente('lotes')">📦 Lotes em Andamento</button>
        <button id="btnNavCliFinalizados" class="btn-pag-op" onclick="navegarPaginaCliente('finalizados')">✅ Concluídos / Liberados</button>
        <button id="btnNavCliAgendar" class="btn-pag-op" onclick="navegarPaginaCliente('agendar')">📅 Agendar Envio</button>
        <button id="btnNavCliEncarte" class="btn-pag-op" onclick="navegarPaginaCliente('encarte')">📇 Modelos de Encarte</button>
        <button id="btnNavCliInsumos" class="btn-pag-op" onclick="navegarPaginaCliente('insumos')">📦 Meu Estoque Insumos</button>
        <button id="btnNavCliMensagens" class="btn-pag-op" onclick="navegarPaginaCliente('mensagens')">
          💬 Central Recados <span id="badgeNotifMensagensCli" class="badge-msg-alert" style="display:none;">🔴 1</span>
        </button>
      </div>

      <!-- ABA 1 CLIENTE: LOTES EM ANDAMENTO -->
      <div id="pagCliLotes">
        <div id="containerLotesClientePainel" class="cards-grid-amplos"></div>
      </div>

      <!-- ABA 2 CLIENTE: LOTES FINALIZADOS -->
      <div id="pagCliFinalizados" style="display:none;">
        <div id="containerLotesFinalizadosClientePainel" class="cards-grid-amplos"></div>
      </div><!-- ABA 3 CLIENTE: AGENDAR ENVIO -->
      <div id="pagCliAgendar" style="display:none;">
        <h3 style="margin-top:0;">Agendamento de Envio de Peças</h3>
        <p style="font-size:0.85rem; color:var(--text-muted);">Selecione um dia disponível (em verde) e informe o volume de peças ou o peso estimado.</p>
        
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
          <button class="btn-main" style="width:auto; padding:6px 14px;" onclick="mudarMesCalendario(-1)">◄ Mês Anterior</button>
          <strong id="calMesAnoHeader" style="font-size:1.1rem; color:var(--header-bg);"></strong>
          <button class="btn-main" style="width:auto; padding:6px 14px;" onclick="mudarMesCalendario(1)">Próximo Mês ►</button>
        </div>

        <div id="containerCalendarioGrid" class="cal-grid"></div>

        <div style="margin-top:20px; background:#F8FAFC; padding:18px; border-radius:16px; border:1px solid var(--border-color);">
          <h4 style="margin-top:0;">Detalhes do Lote Agendado</h4>
          
          <div style="display:grid; grid-template-columns: 1fr 1fr; gap:12px;">
            <div>
              <label style="font-size:0.8rem; font-weight:700;">Qtd Peças (Estimada):</label>
              <input type="number" id="inputAgendQtdPcs" class="form-control" placeholder="Ex: 500" oninput="calcularPesoPorPcsCli()">
            </div>
            <div>
              <label style="font-size:0.8rem; font-weight:700;">Peso Estimado (g):</label>
              <input type="number" id="inputAgendPesoGramos" class="form-control" placeholder="Ex: 1050" oninput="calcularPcsPorPesoCli()">
            </div>
          </div>

          <p id="labelCalcAgendResult" style="font-size:0.85rem; font-weight:700; color:var(--primary-blue); margin:6px 0 12px 0;"></p>

          <label style="font-size:0.8rem; font-weight:700;">Modelos / Referências Aproximadas:</label>
          <input type="number" id="inputAgendQtdModelos" class="form-control" placeholder="Ex: 15 modelos" value="1">

          <label style="font-size:0.8rem; font-weight:700;">Observações ou Instruções Iniciais:</label>
          <textarea id="inputAgendObs" class="form-control" placeholder="Observações para a equipe Clube S.O.S..."></textarea>

          <button class="btn-main btn-green" onclick="confirmarAgendamentoLoteClienteSubmit()">CONFIRMAR AGENDAMENTO DE ENVIO ➔</button>
        </div>
      </div>

      <!-- ABA 4 CLIENTE: ENCARTES -->
      <div id="pagCliEncarte" style="display:none;">
        <h3 style="margin-top:0;">Modelos de Encarte Cadastrados</h3>
        <div id="containerEncartesClienteExibicao" class="cards-grid-amplos"></div>
      </div>

      <!-- ABA 5 CLIENTE: INSUMOS -->
      <div id="pagCliInsumos" style="display:none;">
        <h3 style="margin-top:0;">Estoque de Insumos da Minha Marca</h3>
        <div id="containerTabelaInsumosClienteExibicao"></div>
      </div>

      <!-- ABA 6 CLIENTE: MENSAGENS -->
      <div id="pagCliMensagens" style="display:none;">
        <h3 style="margin-top:0;">Central de Comunicados e Recados</h3>
        <div id="boxMensagensRecebidasCli" style="background:#F8FAFC; padding:16px; border-radius:14px; margin-bottom:16px; max-height:250px; overflow-y:auto;"></div>
        <textarea id="inputTextoEnvioCli" class="form-control" placeholder="Enviar uma mensagem para a Diretoria..."></textarea>
        <button class="btn-main" onclick="enviarMensagemClienteSubmit()">ENVIAR MENSAGEM ➔</button>
      </div>
    </div>
  </div><!-- PAINEL COLABORADOR (EQUIPE OPERACIONAL) -->
  <div id="painelColaborador" style="display:none;">
    <div class="card-panel">
      <h2 style="margin-top:0; color:var(--header-bg);">🛠️ BANCADA OPERACIONAL — CLUBE S.O.S.</h2>
      <p id="subtituloColabBancada" style="font-size:0.85rem; color:var(--text-muted); font-weight:600;"></p>

      <div class="nav-tabs-bar">
        <button id="btnNavOpLotes" class="btn-pag-op active" onclick="navegarPaginaColab('lotes')">⚡ Lotes no Meu Setor</button>
        <button id="btnNavOpRegras" class="btn-pag-op" onclick="navegarPaginaColab('regras')">📖 Consultar Regras</button>
        <button id="btnNavOpEncartes" class="btn-pag-op" onclick="navegarPaginaColab('encartes')">📇 Consultar Encartes</button>
        <button id="btnNavOpInsumos" class="btn-pag-op" onclick="navegarPaginaColab('insumos')">📦 Estoque de Insumos</button>
        <button id="btnNavOpMensagens" class="btn-pag-op" onclick="navegarPaginaColab('mensagens')">💬 Avisos da Diretoria</button>
      </div>

      <div id="pagOpLotes">
        <div id="containerColabMeuSetor" class="cards-grid-amplos"></div>
      </div>

      <div id="pagOpRegras" style="display:none;">
        <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-bottom:16px;">
          <select id="selectFiltroSetorRegrasColab" class="form-control" onchange="renderizarRegrasSetoresColab()"></select>
          <select id="selectFiltroClienteRegrasColab" class="form-control" onchange="renderizarRegrasSetoresColab()"></select>
        </div>
        <div id="containerCardsRegrasColabConsulta"></div>
      </div>

      <div id="pagOpEncartes" style="display:none;">
        <select id="selectFiltroClienteEncarteColab" class="form-control" onchange="renderizarEncartesColabConsulta()"></select>
        <div id="containerCardsEncarteColabConsulta" class="cards-grid-amplos"></div>
      </div>

      <div id="pagOpInsumos" style="display:none;">
        <select id="selectFiltroClienteInsumoColab" class="form-control" onchange="renderizarInsumosColabConsulta()"></select>
        <div id="containerTabelaInsumosColabConsulta"></div>
      </div>

      <div id="pagOpMensagens" style="display:none;">
        <div id="boxMensagensRecebidasColab" style="background:#F8FAFC; padding:16px; border-radius:14px; margin-bottom:16px; max-height:250px; overflow-y:auto;"></div>
        <textarea id="inputTextoEnvioColab" class="form-control" placeholder="Enviar recado para a Diretoria..."></textarea>
        <button class="btn-main" onclick="enviarMensagemColabSubmit()">ENVIAR MENSAGEM ➔</button>
      </div>
    </div>
  </div><!-- PAINEL DIRETORIA (GESTAO GERAL) -->
  <div id="painelDiretoria" style="display:none;">
    <div class="card-panel">
      <h2 style="margin-top:0; color:var(--header-bg);">👑 PAINEL DA DIRETORIA E GESTÃO</h2>

      <div class="nav-tabs-bar">
        <button id="btnNavLotes" class="btn-pag-dir active" onclick="navegarPaginaDiretoria('lotes')">📦 Visão Geral dos Lotes</button>
        <button id="btnNavClientes" class="btn-pag-dir" onclick="navegarPaginaDiretoria('clientes')">👥 Marcas & Clientes</button>
        <button id="btnNavColab" class="btn-pag-dir" onclick="navegarPaginaDiretoria('colab')">🛠️ Equipe Operacional</button>
        <button id="btnNavInsumos" class="btn-pag-dir" onclick="navegarPaginaDiretoria('insumos')">📦 Gestão de Insumos</button>
        <button id="btnNavEncarte" class="btn-pag-dir" onclick="navegarPaginaDiretoria('encarte')">📇 Modelos de Encarte</button>
        <button id="btnNavRegras" class="btn-pag-dir" onclick="navegarPaginaDiretoria('regras')">📖 Regras de Setor</button>
        <button id="btnNavHistoricoMsg" class="btn-pag-dir" onclick="navegarPaginaDiretoria('historicoMsg')">💬 Histórico Mensagens</button>
        <button id="btnNavConfigs" class="btn-pag-dir" onclick="navegarPaginaDiretoria('configs')">⚙️ Ajustes & Avisos</button>
      </div>

      <!-- 1. GESTÃO DE LOTES DIRETORIA -->
      <div id="pagDirLotes">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px; gap:12px;">
          <select id="filtroCliLotes4Etapas" class="form-control" style="margin:0; max-width:320px;" onchange="renderizarLotes4Etapas()"></select>
        </div>
        <div id="containerLotes4EtapasAmplo"></div>
      </div>

      <!-- 2. GESTÃO DE CLIENTES DIRETORIA -->
      <div id="pagDirClientes" style="display:none;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
          <h3 style="margin:0;">Clientes Ativos & Inativos</h3>
          <button class="btn-main btn-green" style="width:auto;" onclick="abrirModalCadastrarCliente()">+ NOVO CLIENTE</button>
        </div>
        <div id="containerCardsClientesAmplo" class="cards-grid-amplos" style="margin-bottom:24px;"></div>
        <h4 style="color:var(--text-muted); border-top:1px solid var(--border-color); padding-top:16px;">Clientes Inativos</h4>
        <div id="containerCardsClientesInativos" class="cards-grid-amplos"></div>
      </div>

      <!-- 3. GESTÃO DE COLABORADORES DIRETORIA -->
      <div id="pagDirColab" style="display:none;">
        <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
          <h3 style="margin:0;">Equipe Operacional</h3>
          <button class="btn-main btn-green" style="width:auto;" onclick="abrirModalCadastrarColaborador()">+ NOVO COLABORADOR</button>
        </div>
        <div id="containerCardsColabAmplo" class="cards-grid-amplos"></div>
      </div>

      <!-- 4. GESTÃO DE INSUMOS DIRETORIA -->
      <div id="pagDirInsumos" style="display:none;">
        <div id="secaoSelecaoClienteInsumo">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
            <h3 style="margin:0;">Selecione uma Marca para Gerenciar Insumos</h3>
            <button class="btn-main btn-green" style="width:auto;" onclick="abrirModalCadastrarInsumo('')">+ NOVO INSUMO GERAL</button>
          </div>
          <div id="containerCardsClientesInsumosSelection" class="cards-grid-amplos"></div>
          <h4 style="color:var(--text-muted); border-top:1px solid var(--border-color); padding-top:16px; margin-top:20px;">Marcas Inativas</h4>
          <div id="containerCardsClientesInsumosInativosSelection" class="cards-grid-amplos"></div>
        </div>

        <div id="secaoDetalheInsumosClienteSel" style="display:none;">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
            <button class="btn-main" style="width:auto; background:#64748B;" onclick="voltarSelecaoClienteInsumo()">◄ VOLTAR ÀS MARCAS</button>
            <h3 id="tituloInsumosClienteSel" style="margin:0;"></h3>
            <button class="btn-main btn-green" style="width:auto;" onclick="abrirModalCadastrarInsumoParaClienteAtual()">+ CADASTRAR INSUMO</button>
          </div>
          <div id="containerInsumosTabelaDirect"></div>
        </div>
      </div>

      <!-- 5. GESTÃO DE ENCARTES DIRETORIA -->
      <div id="pagDirEncarte" style="display:none;">
        <div id="secaoSelecaoClienteEncarte">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
            <h3 style="margin:0;">Modelos de Encarte por Marca</h3>
            <button class="btn-main btn-green" style="width:auto;" onclick="abrirModalCadastrarModeloEncarte()">+ NOVO MODELO DE ENCARTE</button>
          </div>
          <div id="containerCardsClientesEncarteSelection" class="cards-grid-amplos"></div>
          <h4 style="color:var(--text-muted); border-top:1px solid var(--border-color); padding-top:16px; margin-top:20px;">Marcas Inativas</h4>
          <div id="containerCardsClientesIncarteInativosSelection" class="cards-grid-amplos"></div>
        </div>

        <div id="secaoDetalheEncarteClienteSel" style="display:none;">
          <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
            <button class="btn-main" style="width:auto; background:#64748B;" onclick="voltarSelecaoClienteEncarte()">◄ VOLTAR ÀS MARCAS</button>
            <h3 id="tituloEncarteClienteSel" style="margin:0;"></h3>
            <button class="btn-main btn-green" style="width:auto;" onclick="abrirModalCadastrarModeloEncarte()">+ NOVO MODELO</button>
          </div>
          <div id="containerCardsCategoriasEncarteClienteSel" class="cards-grid-amplos"></div>
        </div>
      </div>

      <!-- 6. GESTÃO DE REGRAS DE SETOR DIRETORIA -->
      <div id="pagDirRegras" style="display:none;">
        <div style="display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-bottom:16px;">
          <select id="selectFiltroSetorRegrasDir" class="form-control" onchange="renderizarCardsSetoresRegrasDir()"></select>
          <select id="selectFiltroClienteRegrasDir" class="form-control" onchange="renderizarCardsSetoresRegrasDir()"></select>
        </div>
        <div id="containerCardsSetoresRegrasDir" class="cards-grid-amplos"></div>
      </div>

      <!-- 7. HISTÓRICO DE MENSAGENS (DIRETORIA) -->
      <div id="pagDirHistoricoMsg" style="display:none;">
        <h3 style="margin-top:0;">💬 Histórico Geral de Conversas e Recados</h3>
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px; margin-bottom:16px;">
          <div>
            <label style="font-size:0.78rem; font-weight:700;">Filtrar por Cliente:</label>
            <select id="selectFiltroMsgClienteDir" class="form-control" onchange="renderizarHistoricoMensagensDiretoria()"></select>
          </div>
          <div>
            <label style="font-size:0.78rem; font-weight:700;">Filtrar por Colaborador:</label>
            <select id="selectFiltroMsgColabDir" class="form-control" onchange="renderizarHistoricoMensagensDiretoria()"></select>
          </div>
        </div>
        <div id="containerHistoricoMensagensDiretoria" style="background:#F8FAFC; padding:18px; border-radius:16px; border:1px solid var(--border-color); max-height:450px; overflow-y:auto;"></div>
      </div>

      <!-- 8. CONFIGURAÇÕES DA FABRICA & AVISOS -->
      <div id="pagDirConfigs" style="display:none;">
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:20px;">
          <div style="background:#F8FAFC; padding:18px; border-radius:16px; border:1px solid var(--border-color);">
            <h4 style="margin-top:0;">Categorias de Joias Central</h4>
            <div id="boxListaCategoriasJoiasCentral" style="margin-bottom:12px;"></div>
            <div style="display:flex; gap:6px;">
              <input type="text" id="inputNovaCatJoia" class="form-control" style="margin:0;" placeholder="Nova categoria...">
              <button class="btn-main btn-green" style="width:auto;" onclick="cadastrarNovaCategoriaJoiaSubmit()">+ ADICIONAR</button>
            </div>
          </div>

          <div style="background:#F8FAFC; padding:18px; border-radius:16px; border:1px solid var(--border-color);">
            <h4 style="margin-top:0;">Cálculo de Média de Peso (Peça -> Gramas)</h4>
            <label style="font-size:0.8rem; font-weight:700;">Fator Médio (Gramas por Peça):</label>
            <input type="number" step="0.1" id="inputFatorDivisorDir" class="form-control" value="2.1">
            <button class="btn-main" onclick="salvarFatorDivisorSubmit()">SALVAR FATOR DIVISOR</button>
          </div>
        </div>

        <div style="background:#F8FAFC; padding:18px; border-radius:16px; border:1px solid var(--border-color); margin-top:20px;">
          <h4 style="margin-top:0;">Emitir Comunicado Geral / Recado</h4>
          <label style="font-size:0.8rem; font-weight:700;">Enviar Para:</label>
          <select id="selectTipoDestinatarioAviso" class="form-control" onchange="alternarExibicaoDestinatariosAviso()">
            <option value="TODOS">Todos (Clientes e Equipe)</option>
            <option value="TODOS_CLIENTES">Todos os Clientes</option>
            <option value="TODOS_COLABORADORES">Toda a Equipe Operacional</option>
            <option value="SELECIONAR_CLIENTES">Selecionar Clientes Específicos</option>
            <option value="SELECIONAR_COLABORADORES">Selecionar Colaboradores Específicos</option>
          </select>

          <div id="boxSelecaoClientesAviso" style="display:none; background:#FFFFFF; padding:10px; border-radius:10px; border:1px solid var(--border-color); margin-bottom:12px; max-height:120px; overflow-y:auto;"></div>
          <div id="boxSelecaoColabAviso" style="display:none; background:#FFFFFF; padding:10px; border-radius:10px; border:1px solid var(--border-color); margin-bottom:12px; max-height:120px; overflow-y:auto;"></div>

          <textarea id="textoAvisoDir" class="form-control" placeholder="Texto do comunicado oficial..."></textarea>
          <button class="btn-main btn-green" onclick="salvarAvisoComunicadoSubmit()">PUBLICAR COMUNICADO ➔</button>
        </div>
      </div>
    </div>
  </div><!-- MODAL DE DETALHES COMPLETO DO LOTE (VISÃO CLIENTE E GERAL) -->
  <div id="modalDetalheCompletoLote" class="modal-overlay">
    <div class="modal-card">
      <div style="display:flex; justify-content:space-between; align-items:center; border-bottom:2px solid #E2E8F0; padding-bottom:12px; margin-bottom:16px;">
        <h3 style="margin:0; color:var(--header-bg);" id="mDetLoteTitulo">Relatório Detalhado do Lote</h3>
        <button style="background:none; border:none; font-size:1.4rem; font-weight:bold; cursor:pointer;" onclick="fecharModalDetalheLote()">✕</button>
      </div>
      <div id="mDetLoteConteudo"></div>
      <button class="btn-main" style="background:#64748B; margin-top:18px;" onclick="fecharModalDetalheLote()">FECHAR</button>
    </div>
  </div>

  <!-- MODAL ADICIONAR REGRA DO SETOR -->
  <div id="modalAddRegraSetor" class="modal-overlay">
    <div class="modal-card" style="max-width:550px;">
      <h3 style="margin-top:0;" id="tituloModalRegraSetor">Adicionar Regra</h3>
      <input type="hidden" id="hiddenRegraSetorNome">
      <select id="mRegraSelectCliente" class="form-control"></select>
      <textarea id="mRegraTexto" class="form-control" style="height:90px;" placeholder="Instrução / Regra..."></textarea>
      <button class="btn-main btn-green" onclick="salvarNovaRegraSetorSubmit()">SALVAR REGRA</button>
      <button class="btn-main" style="background:#94A3B8; margin-top:8px;" onclick="fecharModalAddRegraSetor()">CANCELAR</button>
    </div>
  </div>

  <!-- MODAL BANCADA OPERACIONAL (COLABORADOR) COM SERVIÇOS ADICIONAIS -->
  <div id="modalOpBancadaLote" class="modal-overlay">
    <div class="modal-card" style="max-width:600px;">
      <h3 style="margin-top:0;" id="tituloModalOpLote">Atuação Operacional do Lote</h3>
      <input type="hidden" id="hiddenOpLoteId">
      
      <div style="background:#F1F5F9; padding:12px; border-radius:12px; margin-bottom:15px; border:1px solid var(--border-color);">
        <p style="margin:2px 0; font-weight:700;" id="infoOpLoteMarca"></p>
        <p style="margin:2px 0; color:var(--text-muted);" id="infoOpLoteSetor"></p>
        <p style="margin:4px 0 0 0; font-size:0.8rem; font-weight:800; color:var(--primary-blue);" id="infoOpLoteStatusInicio">Status do Setor: Não Iniciado</p>
      </div>
      
      <!-- CONTROLE DE TEMPO DO SETOR -->
      <div style="margin-bottom:15px; background:#ECFDF5; border:1px solid #10B981; padding:12px; border-radius:12px; text-align:center;">
        <button id="btnIniciarSetorBancada" class="btn-main btn-green" style="margin-bottom:6px;" onclick="iniciarSetorBancadaSubmit()">▶️ INICIAR PROCESSO NESTE SETOR</button>
        <span id="stampHoraInicioRegistrada" style="font-size:0.75rem; font-weight:800; color:#065F46; display:none;"></span>
      </div>

      <!-- SEÇÃO EXCLUSIVA: SERVIÇOS ADICIONAIS (EX: INSPEÇÃO 3EM1 / CRAVAÇÃO / MONTAGEM / COLAGEM) -->
      <div id="boxServicosAdicionaisInspecao" class="box-servico-adicional" style="display:none;">
        <h4 style="margin:0 0 8px 0; color:#0D9488; font-size:0.9rem;">🛠️ Registrar Trabalhos Adicionais (Cravação / Montagem / Colagem)</h4>
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:8px;">
          <div>
            <label style="font-size:0.75rem; font-weight:700;">Tipo de Trabalho:</label>
            <select id="selectTipoServicoAdicional" class="form-control" style="margin-bottom:6px;">
              <option value="Cravação de Pedras">Cravação de Pedras</option>
              <option value="Montagem de Peças">Montagem de Peças</option>
              <option value="Colagem de Cristais/Pedras">Colagem de Cristais/Pedras</option>
              <option value="Solda / Ajuste Técnico">Solda / Ajuste Técnico</option>
              <option value="Outro Trabalho Especial">Outro Trabalho Especial</option>
            </select>
          </div>
          <div>
            <label style="font-size:0.75rem; font-weight:700;">Qtd Peças Trabalhadas:</label>
            <input type="number" id="inputQtdServicoAdicional" class="form-control" style="margin-bottom:6px;" placeholder="Ex: 50">
          </div>
        </div>
        <button type="button" class="btn-main" style="background:#0D9488; padding:6px; font-size:0.75rem; margin-top:4px;" onclick="adicionarServicoEspecialLista()">+ INCLUIR TRABALHO NO RELATÓRIO</button>
        <div id="listaServicosEspeciaisAdicionados" style="margin-top:8px; font-size:0.8rem;"></div>
      </div>

      <label style="font-size:0.78rem; font-weight:700;">Qtd Total Declarada do Lote:</label>
      <input type="number" id="inputOpQtdReal" class="form-control" placeholder="Qtd Real Contada...">
      
      <label style="font-size:0.78rem; font-weight:700; color:var(--orange-accent);">* Qtd Produzida Neste Setor (OBRIGATÓRIO PARA AVANÇAR):</label>
      <input type="number" id="inputOpQtdServicoSetor" class="form-control" placeholder="Ex: 300 (Inspeções / Fotos / Cadastros / Encartes...)">
      <span id="msgAvisoQtdObrig" style="display:none; color:red; font-size:0.75rem; font-weight:800; margin-bottom:8px;">⚠️ A quantidade é obrigatória para este setor!</span>
      
      <label style="font-size:0.78rem; font-weight:700;">Modelos Identificados:</label>
      <input type="number" id="inputOpQtdModelosReal" class="form-control" placeholder="Modelos Identificados...">
      
      <label style="font-size:0.78rem; font-weight:700;">Avançar Para o Próximo Setor:</label>
      <select id="selectOpProximoSetor" class="form-control">
        <option value="2. Inspeção 3em1">2. Inspeção 3em1</option>
        <option value="3. Fotografia">3. Fotografia</option>
        <option value="4. CDE Catalogação">4. CDE Catalogação</option>
        <option value="5. Etiquetagem">5. Etiquetagem</option>
        <option value="6. Encartelamento">6. Encartelamento</option>
        <option value="7. Finalização / Liberado">7. Finalização / Liberado</option>
      </select>
      
      <label style="font-size:0.78rem; font-weight:700;">Observação Técnica do Setor (Opcional):</label>
      <input type="text" id="inputOpObs" class="form-control" placeholder="Observações específicas...">
      
      <button class="btn-main btn-orange" onclick="concluirAvançarLoteBancadaSubmit()">CONCLUIR SETOR E AVANÇAR ➔</button>
      <button class="btn-main" style="background:#94A3B8; margin-top:8px;" onclick="fecharModalOpBancadaLote()">CANCELAR</button>
    </div>
  </div>

  <!-- MODAL EDITAR / FINALIZAR / EXCLUIR LOTE (DIRETORIA) -->
  <div id="modalEditarLoteDir" class="modal-overlay">
    <div class="modal-card" style="max-width:750px;">
      <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:12px;">
        <h3 style="margin:0; color:var(--header-bg);">Gestão Completa do Lote (Diretoria)</h3>
        <button class="btn-main btn-danger" style="width:auto; padding:6px 12px; font-size:0.75rem;" onclick="excluirLoteDefinitivoDir()">🗑️ EXCLUIR LOTE</button>
      </div>
      <input type="hidden" id="editLoteIdHidden">
      
      <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
        <div>
          <label style="font-size:0.78rem; font-weight:700;">Nº do Lote:</label>
          <input type="text" id="editLoteNum" class="form-control" placeholder="Nº Lote...">
        </div>
        <div>
          <label style="font-size:0.78rem; font-weight:700;">Volume de Peças (Total):</label>
          <input type="number" id="editLotePcs" class="form-control" placeholder="Total pcs..." oninput="calcularValoresFinanceirosEditLote()">
        </div>
      </div>

      <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
        <div>
          <label style="font-size:0.78rem; font-weight:700;">Etapa do Lote:</label>
          <select id="editLoteEtapa" class="form-control">
            <option value="1">1. Aguardando Aprovação</option>
            <option value="2">2. Aguardando Chegada Física</option>
            <option value="3">3. Cadastrado / Em Andamento</option>
            <option value="4">4. Finalizado / Liberado</option>
          </select>
        </div>
        <div>
          <label style="font-size:0.78rem; font-weight:700;">Setor Atual:</label>
          <select id="editLoteSetorAtual" class="form-control">
            <option value="1. Entrada Bruta">1. Entrada Bruta</option>
            <option value="2. Inspeção 3em1">2. Inspeção 3em1</option>
            <option value="3. Fotografia">3. Fotografia</option>
            <option value="4. CDE Catalogação">4. CDE Catalogação</option>
            <option value="5. Etiquetagem">5. Etiquetagem</option>
            <option value="6. Encartelamento">6. Encartelamento</option>
            <option value="7. Finalização / Liberado">7. Finalização / Liberado</option>
          </select>
        </div>
      </div>

      <!-- PAINEL EDITÁVEL DE HISTÓRICO DE SETORES, TEMPOS E QUANTIDADES -->
      <div style="margin-bottom:15px; background:#F8FAFC; padding:14px; border-radius:14px; border:1px solid var(--border-color);">
        <h4 style="margin:0 0 8px 0; color:var(--header-bg); font-size:0.88rem;">📊 Histórico e Edição dos Setores Operacionais:</h4>
        <div id="containerHistoricoSetoresDiretoria"></div>
      </div>

      <!-- PAINEL FINANCEIRO DE CÁLCULO E DESCONTO AUTOMÁTICO -->
      <div style="background:#F0F9FF; border:1px solid #0284C7; padding:14px; border-radius:14px; margin-bottom:12px;">
        <h4 style="margin:0 0 8px 0; color:#0369A1;">💰 Fechamento Financeiro & Valores</h4>
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
          <div>
            <label style="font-size:0.75rem; font-weight:700;">Valor Bruto Total (R$):</label>
            <input type="number" step="0.01" id="editLoteValorBruto" class="form-control" placeholder="Ex: 780.15" oninput="calcularValoresFinanceirosEditLote()">
          </div>
          <div>
            <label style="font-size:0.75rem; font-weight:700;">Desconto (%):</label>
            <input type="number" step="0.1" id="editLoteDesconto" class="form-control" placeholder="Ex: 7" oninput="calcularValoresFinanceirosEditLote()">
          </div>
        </div>
        
        <div style="background:#FFFFFF; padding:10px; border-radius:10px; margin-top:8px; border:1px solid #BAE6FD;">
          <div style="display:flex; justify-content:space-between; font-weight:700; font-size:0.85rem;">
            <span>Valor Total com Desconto:</span>
            <span id="labelValTotalComDesconto">R$ 0,00</span>
          </div>
          <div style="display:flex; justify-content:space-between; font-weight:700; font-size:0.85rem; margin-top:4px; color:var(--primary-blue);">
            <span>Valor Unitário por Peça:</span>
            <span id="labelValPorPecaFinal">R$ 0,00 / und</span>
          </div>
        </div>
      </div>

      <label style="font-size:0.78rem; font-weight:700;">Observações Gerais do Lote:</label>
      <textarea id="editLoteObs" class="form-control" placeholder="Observações..."></textarea>
      
      <button class="btn-main btn-green" onclick="salvarEdicaoLoteDir()">SALVAR ALTERAÇÕES DO LOTE</button>
      <button class="btn-main" style="background:#94A3B8; margin-top:8px;" onclick="fecharModalEditarLoteDir()">CANCELAR</button>
    </div>
  </div>

  <!-- DEMAIS MODAIS -->
  <div id="modalCadCliente" class="modal-overlay">
    <div class="modal-card" style="max-width:550px;">
      <h3 id="modalClienteTitulo" style="margin-top:0;">Cadastrar Cliente</h3>
      <input type="hidden" id="mEditCliIdHidden">
      <input type="text" id="mCadCliNome" class="form-control" required placeholder="Marca...">
      <input type="text" id="mCadCliLogin" class="form-control" required placeholder="Login/E-mail...">
      <input type="text" id="mCadCliSenha" class="form-control" required value="123">
      <select id="mCadCliCat" class="form-control">
        <option value="Iniciante">🥉 Iniciante (Até 500 und/mês)</option>
        <option value="Ouro">🥇 VIP Ouro (Até 1.000 und/mês)</option>
        <option value="Diamante" selected>💎 VIP Diamante (Até 1.500 und/mês)</option>
        <option value="Black">👑 VIP Black (Até 2.000 und/mês)</option>
      </select>
      <input type="text" id="mCadCliInicio" class="form-control" required placeholder="Mês/Ano Início...">
      <button class="btn-main btn-green" onclick="salvarClienteModalSubmit()">SALVAR CLIENTE</button>
      <button type="button" class="btn-main" style="background:#94A3B8; margin-top:8px;" onclick="fecharModalCadCliente()">CANCELAR</button>
    </div>
  </div>

  <div id="modalCadColaborador" class="modal-overlay">
    <div class="modal-card" style="max-width:600px;">
      <h3 id="modalColabTitulo" style="margin-top:0;">Cadastrar Colaborador</h3>
      <input type="hidden" id="mEditColabIdHidden">
      <input type="text" id="mCadColabNome" class="form-control" required placeholder="Nome...">
      <input type="text" id="mCadColabFone" class="form-control" required placeholder="Telefone...">
      <input type="text" id="mCadColabLogin" class="form-control" required placeholder="Login...">
      <input type="text" id="mCadColabSenha" class="form-control" required value="123">
      
      <label style="font-size:0.8rem; font-weight:700; display:block; margin-bottom:6px; color:var(--header-bg);">Áreas / Setores Liberados:</label>
      <div id="boxSetoresTagsColab">
        <span class="tag-setor-btn" data-setor="1. Entrada Bruta" onclick="toggleSetorTag(this)">1. Entrada Bruta</span>
        <span class="tag-setor-btn" data-setor="2. Inspeção 3em1" onclick="toggleSetorTag(this)">2. Inspeção 3em1</span>
        <span class="tag-setor-btn" data-setor="3. Fotografia" onclick="toggleSetorTag(this)">3. Fotografia</span>
        <span class="tag-setor-btn" data-setor="4. CDE Catalogação" onclick="toggleSetorTag(this)">4. CDE Catalogação</span>
        <span class="tag-setor-btn" data-setor="5. Etiquetagem" onclick="toggleSetorTag(this)">5. Etiquetagem</span>
        <span class="tag-setor-btn" data-setor="6. Encartelamento" onclick="toggleSetorTag(this)">6. Encartelamento</span>
        <span class="tag-setor-btn" data-setor="7. Finalização" onclick="toggleSetorTag(this)">7. Finalização</span>
      </div>
      <button class="btn-main btn-orange" style="margin-top:16px;" onclick="salvarColaboradorModalSubmit()">SALVAR COLABORADOR</button>
      <button type="button" class="btn-main" style="background:#94A3B8; margin-top:8px;" onclick="fecharModalCadColaborador()">CANCELAR</button>
    </div>
  </div>

  <div id="modalCadInsumo" class="modal-overlay">
    <div class="modal-card" style="max-width:550px;">
      <h3 id="modalInsumoTitulo" style="margin-top:0;">Cadastrar Insumo</h3>
      <form onsubmit="salvarNovoInsumoSubmit(event)">
        <input type="hidden" id="mEditInsumoCliOriginalHidden">
        <input type="hidden" id="mEditInsumoIdxHidden">
        
        <label style="font-size:0.78rem; font-weight:700;">Cliente / Marca Pertencente:</label>
        <select id="mCadInsCli" class="form-control"></select>
        
        <label style="font-size:0.78rem; font-weight:700; margin-top:6px; display:block;">Categorias de Joias Atribuídas:</label>
        <div id="boxCatJoiasInsumoTags" style="margin-bottom:12px; background:#F8FAFC; padding:8px; border-radius:10px;"></div>
        
        <label style="font-size:0.78rem; font-weight:700;">Tipo de Insumo:</label>
        <select id="mCadInsTipo" class="form-control"></select>
        <div style="display:flex; gap:6px; margin-bottom:12px;">
          <input type="text" id="inputNovoTipoInsumoTemp" class="form-control" style="margin:0;" placeholder="Novo tipo...">
          <button type="button" class="btn-main btn-orange" style="width:auto; padding:0 12px; font-size:0.75rem;" onclick="adicionarNovoTipoInsumoDirect()">+ ADICIONAR</button>
        </div>

        <label style="font-size:0.78rem; font-weight:700;">Subcategoria / Descrição:</label>
        <input type="text" id="mCadInsSub" class="form-control" required placeholder="Subcategoria/Tamanho...">
        
        <label style="font-size:0.78rem; font-weight:700;">Quantidade em Estoque:</label>
        <input type="number" id="mCadInsQtd" class="form-control" required placeholder="Quantidade...">
        
        <label style="font-size:0.78rem; font-weight:700;">Gôndola / Localização:</label>
        <input type="text" id="mCadInsGondula" class="form-control" placeholder="Gôndola...">
        
        <button type="submit" class="btn-main btn-green" id="btnSalvarModalInsumo">SALVAR INSUMO</button>
        <button type="button" class="btn-main" style="background:#94A3B8; margin-top:8px;" onclick="fecharModalCadInsumo()">CANCELAR</button>
      </form>
    </div>
  </div>

  <div id="modalCadModeloEncarte" class="modal-overlay">
    <div class="modal-card" style="max-width:700px;">
      <h3 style="margin-top:0;">Cadastrar Modelo de Encarte</h3>
      <form onsubmit="salvarModeloEncarteCompletoSubmit(event)">
        <select id="mCadEncCli" class="form-control" onclick="atualizarSelectsInsumosModeloEncarte()"></select>
        <select id="mCadEncCatJoia" class="form-control"></select>
        <div style="display:flex; gap:6px; margin-bottom:8px;">
          <input type="text" id="inputPassoEncarteTemp" class="form-control" style="margin:0;" placeholder="Instrução do passo...">
          <button type="button" class="btn-main btn-orange" style="width:auto; padding:0 14px;" onclick="adicionarPassoEncarteLista()">+ ADD</button>
        </div>
        <div id="containerPassosEncarteLista" style="background:#F8FAFC; border:1px solid #CBD5E1; padding:10px; border-radius:10px; margin-bottom:12px; min-height:60px;"></div>
        <select id="mCadEncSaquinho" class="form-control"></select>
        <select id="mCadEncCartela" class="form-control"></select>
        <input type="text" id="mCadEncFotoFrente" class="form-control" required placeholder="Link Foto Frente Drive...">
        <input type="text" id="mCadEncFotoVerso" class="form-control" required placeholder="Link Foto Verso Drive...">
        <input type="text" id="mCadEncObs" class="form-control" placeholder="Observações...">
        <button type="submit" class="btn-main btn-orange">SALVAR MODELO DE ENCARTE</button>
        <button type="button" class="btn-main" style="background:#94A3B8; margin-top:8px;" onclick="fecharModalCadModeloEncarte()">CANCELAR</button>
      </form>
    </div>
  </div><script>
    var GOOGLE_API_URL = "https://script.google.com/macros/s/AKfycbx_okio68ZvoCLOyzdZgG5qdIWp1IBQJjFLu9Gi2Cq6sNzoVw9ZsRn8ZUsHKfQy-ErFPQ/exec";

    var perfilAcessoSelecionadoTab = 'cliente';
    var usuarioLogadoObjeto = null;
    var dataAgendamentoSelecionadaCli = "";
    var fatorMediaPesoGlobal = 2.1;
    var dadosCarregadosDaNovem = false;
    var clienteInsumosSelecionadoAtual = "";
    var listaServicosAdicionaisTemp = [];

    var DATA_HOJE_SISTEMA = new Date();
    var anoCalendarioAtual = DATA_HOJE_SISTEMA.getFullYear();
    var mesCalendarioAtual = DATA_HOJE_SISTEMA.getMonth();

    var feriadosLimeiraSP = ["2026-01-01", "2026-04-03", "2026-04-21", "2026-05-01", "2026-06-04", "2026-07-09", "2026-09-07", "2026-09-15", "2026-10-12", "2026-11-02", "2026-11-15", "2026-11-20", "2026-12-25"];
    var datasOcupadasAgenda = [];

    var bancoDiretoria = [{ id: 'dir1', nome: 'Kelvin (Diretoria)', login: 'kelvin', senha: '123' }];
    var bancoClientes = [];
    var bancoClientesInativos = [];
    var bancoColaboradores = [];

    var listaSetoresFabricaGeral = ["1. Entrada Bruta", "2. Inspeção 3em1", "3. Fotografia", "4. CDE Catalogação", "5. Etiquetagem", "6. Encartelamento", "7. Finalização"];
    var bancoCategoriasJoias = ["Anel Regulável", "Anel Tradicional", "Brinco Pequeno", "Brinco Grande", "Colar Grande", "Choker", "Infantil", "Pulseira", "Tornozeleira"];
    var bancoTiposInsumos = ["Cartela", "Saquinho", "Tag / Solapa", "Fecho / Argola", "Trava anel", "Extensor"];

    var bancoInsumosCompletos = {};
    var bancoModelosEncarte = {};
    var bancoRegrasSetores = {};
    var bancoLotes4Etapas = [];
    var bancoMensagens = [];

    function obterDataHoraAtualFormatada() {
      var d = new Date();
      var dia = String(d.getDate()).padStart(2, '0');
      var mes = String(d.getMonth() + 1).padStart(2, '0');
      var ano = d.getFullYear();
      var horas = String(d.getHours()).padStart(2, '0');
      var mins = String(d.getMinutes()).padStart(2, '0');
      return dia + "/" + mes + "/" + ano + " " + horas + ":" + mins;
    }

    function expurgarDadosClientesExcluidos() {
      var marcasValidas = [];
      bancoClientes.forEach(function(c) { marcasValidas.push(c.marca); });
      bancoClientesInativos.forEach(function(c) { marcasValidas.push(c.marca); });

      Object.keys(bancoInsumosCompletos).forEach(function(cli) {
        if (marcasValidas.indexOf(cli) === -1) { delete bancoInsumosCompletos[cli]; }
      });

      Object.keys(bancoModelosEncarte).forEach(function(cli) {
        if (marcasValidas.indexOf(cli) === -1) { delete bancoModelosEncarte[cli]; }
      });

      Object.keys(bancoRegrasSetores).forEach(function(setor) {
        if (Array.isArray(bancoRegrasSetores[setor])) {
          bancoRegrasSetores[setor] = bancoRegrasSetores[setor].filter(function(r) {
            return marcasValidas.indexOf(r.cliente) !== -1;
          });
        }
      });
    }

    function selecionarPerfilAcesso(p) {
      perfilAcessoSelecionadoTab = p;
      document.getElementById('tabCliente').classList.remove('active');
      document.getElementById('tabEquipe').classList.remove('active');
      document.getElementById('tabDiretoria').classList.remove('active');

      var selectAcc = document.getElementById('selectUsuarioLogin');
      selectAcc.innerHTML = "";

      if(p === 'cliente') {
        document.getElementById('tabCliente').classList.add('active');
        if (bancoClientes.length === 0) {
          selectAcc.innerHTML = '<option value="">Carregando clientes...</option>';
        } else {
          bancoClientes.forEach(function(c) { selectAcc.innerHTML += '<option value="' + c.id + '">' + c.marca + ' (' + c.login + ')</option>'; });
        }
      } else if(p === 'equipe') {
        document.getElementById('tabEquipe').classList.add('active');
        if (bancoColaboradores.length === 0) {
          selectAcc.innerHTML = '<option value="">Carregando colaboradores...</option>';
        } else {
          bancoColaboradores.forEach(function(col) { selectAcc.innerHTML += '<option value="' + col.id + '">' + col.nome + ' (' + col.login + ')</option>'; });
        }
      } else {
        document.getElementById('tabDiretoria').classList.add('active');
        bancoDiretoria.forEach(function(d) { selectAcc.innerHTML += '<option value="' + d.id + '">' + d.nome + '</option>'; });
      }
    }

    function carregarDadosNovem() {
      var statusEl = document.getElementById('statusSync');
      if(statusEl) statusEl.innerText = "⏳ Sincronizando Nuvem...";

      var cacheLocal = localStorage.getItem("sos_banco_backup_local");
      if (cacheLocal) {
        try {
          var cData = JSON.parse(cacheLocal);
          if (cData.bancoClientes) bancoClientes = cData.bancoClientes;
          if (cData.bancoColaboradores) bancoColaboradores = cData.bancoColaboradores;
          if (cData.bancoClientesInativos) bancoClientesInativos = cData.bancoClientesInativos;
          if (cData.bancoInsumosCompletos) bancoInsumosCompletos = cData.bancoInsumosCompletos;
          if (cData.bancoModelosEncarte) bancoModelosEncarte = cData.bancoModelosEncarte;
          if (cData.bancoRegrasSetores) bancoRegrasSetores = cData.bancoRegrasSetores;
          if (cData.bancoLotes4Etapas) bancoLotes4Etapas = cData.bancoLotes4Etapas;
          if (cData.bancoMensagens) bancoMensagens = cData.bancoMensagens;
          if (cData.bancoCategoriasJoias) bancoCategoriasJoias = cData.bancoCategoriasJoias;
          if (cData.bancoTiposInsumos) bancoTiposInsumos = cData.bancoTiposInsumos;
          expurgarDadosClientesExcluidos();
          selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
        } catch(e){}
      }

      verificarSessaoSalva();

      fetch(GOOGLE_API_URL + "?action=carregarTudo")
        .then(function(res) { return res.json(); })
        .then(function(dados) {
          dadosCarregadosDaNovem = true;
          if(dados.bancoClientes && dados.bancoClientes.length > 0) bancoClientes = dados.bancoClientes;
          if(dados.bancoClientesInativos) bancoClientesInativos = dados.bancoClientesInativos;
          if(dados.bancoColaboradores && dados.bancoColaboradores.length > 0) {
            bancoColaboradores = dados.bancoColaboradores.map(function(c) {
              if (typeof c.setores === 'string') {
                try { c.setores = JSON.parse(c.setores); } catch(e) { c.setores = []; }
              }
              if (!Array.isArray(c.setores)) c.setores = [];
              return c;
            });
          }
          if(dados.bancoInsumosCompletos && Object.keys(dados.bancoInsumosCompletos).length > 0) bancoInsumosCompletos = dados.bancoInsumosCompletos;
          if(dados.bancoModelosEncarte && Object.keys(dados.bancoModelosEncarte).length > 0) bancoModelosEncarte = dados.bancoModelosEncarte;
          if(dados.bancoRegrasSetores && Object.keys(dados.bancoRegrasSetores).length > 0) bancoRegrasSetores = dados.bancoRegrasSetores;
          if(dados.bancoLotes4Etapas) bancoLotes4Etapas = dados.bancoLotes4Etapas;
          if(dados.bancoMensagens && dados.bancoMensagens.length > 0) bancoMensagens = dados.bancoMensagens;
          if(dados.bancoCategoriasJoias) bancoCategoriasJoias = dados.bancoCategoriasJoias;
          if(dados.bancoTiposInsumos) bancoTiposInsumos = dados.bancoTiposInsumos;

          expurgarDadosClientesExcluidos();
          salvarBackupLocalCache();
          if(statusEl) statusEl.innerText = "☁️ Nuvem Sincronizada";
          selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
          verificarNovasMensagensCliente();
        })
        .catch(function(err) {
          dadosCarregadosDaNovem = true;
          if(statusEl) statusEl.innerText = "☁️ Conectado (Cache Local)";
          expurgarDadosClientesExcluidos();
          selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
          verificarNovasMensagensCliente();
        });
    }

    function salvarBackupLocalCache() {
      var localPayload = {
        bancoClientes: bancoClientes,
        bancoClientesInativos: bancoClientesInativos,
        bancoColaboradores: bancoColaboradores,
        bancoInsumosCompletos: bancoInsumosCompletos,
        bancoModelosEncarte: bancoModelosEncarte,
        bancoRegrasSetores: bancoRegrasSetores,
        bancoLotes4Etapas: bancoLotes4Etapas,
        bancoMensagens: bancoMensagens,
        bancoCategoriasJoias: bancoCategoriasJoias,
        bancoTiposInsumos: bancoTiposInsumos
      };
      localStorage.setItem("sos_banco_backup_local", JSON.stringify(localPayload));
    }

    function verificarSessaoSalva() {
      var sessao = localStorage.getItem("sos_user_session");
      if (sessao) {
        try {
          var data = JSON.parse(sessao);
          usuarioLogadoObjeto = data.usuario;
          abrirPainelLogado(data.perfil, data.usuario.nome || data.usuario.marca || data.usuario.login);
        } catch(e) { selecionarPerfilAcesso('cliente'); }
      } else { selecionarPerfilAcesso('cliente'); }
    }

    function salvarDadosNovem() {
      if (!dadosCarregadosDaNovem) return;

      expurgarDadosClientesExcluidos();
      salvarBackupLocalCache();
      var statusEl = document.getElementById('statusSync');
      if(statusEl) statusEl.innerText = "⏳ Gravando na Nuvem...";

      var payload = {
        action: "salvarTudo",
        bancoClientes: bancoClientes,
        bancoClientesInativos: bancoClientesInativos,
        bancoColaboradores: bancoColaboradores,
        bancoInsumosCompletos: bancoInsumosCompletos,
        bancoModelosEncarte: bancoModelosEncarte,
        bancoRegrasSetores: bancoRegrasSetores,
        bancoLotes4Etapas: bancoLotes4Etapas,
        bancoMensagens: bancoMensagens,
        bancoCategoriasJoias: bancoCategoriasJoias,
        bancoTiposInsumos: bancoTiposInsumos
      };

      var bodyData = new URLSearchParams();
      bodyData.append("dados", JSON.stringify(payload));

      fetch(GOOGLE_API_URL, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: bodyData.toString()
      }).then(function() {
        if(statusEl) statusEl.innerText = "☁️ Salvo na Nuvem";
      }).catch(function() {
        if(statusEl) statusEl.innerText = "⚠️ Salvo no Cache Local";
      });
    }

    function autenticarUsuario(e) {
      e.preventDefault();
      var valId = String(document.getElementById('selectUsuarioLogin').value).trim();
      var passInp = document.getElementById('inputSenha').value.trim();

      if(perfilAcessoSelecionadoTab === 'diretoria') {
        var u = bancoDiretoria.find(function(item) { 
          return String(item.id) === valId || String(item.login).toLowerCase() === valId.toLowerCase(); 
        });
        if(u && (String(u.senha).trim() === passInp || passInp === "123456" || passInp === "123")) {
          usuarioLogadoObjeto = u;
          localStorage.setItem("sos_user_session", JSON.stringify({ perfil: 'diretoria', usuario: u }));
          abrirPainelLogado('diretoria', u.nome);
        } else { alert("❌ Senha incorreta para a Diretoria!"); }
      } else if(perfilAcessoSelecionadoTab === 'cliente') {
        var c = bancoClientes.find(function(item) { 
          return String(item.id) === valId || String(item.login).toLowerCase() === valId.toLowerCase(); 
        });
        if(c && String(c.senha).trim() === passInp) {
          usuarioLogadoObjeto = c;
          localStorage.setItem("sos_user_session", JSON.stringify({ perfil: 'cliente', usuario: c }));
          abrirPainelLogado('cliente', c.marca);
        } else { alert("❌ Senha incorreta para o cliente!"); }
      } else if(perfilAcessoSelecionadoTab === 'equipe') {
        var col = bancoColaboradores.find(function(item) { 
          return String(item.id) === valId || String(item.login).toLowerCase() === valId.toLowerCase(); 
        });
        if(col && String(col.senha).trim() === passInp) {
          usuarioLogadoObjeto = col;
          localStorage.setItem("sos_user_session", JSON.stringify({ perfil: 'equipe', usuario: col }));
          abrirPainelLogado('equipe', col.nome);
        } else { alert("❌ Senha incorreta para o colaborador!"); }
      }
    }

    function abrirPainelLogado(perfil, loginStr) {
      document.getElementById('loginScreen').style.display = 'none';
      document.getElementById('userBadgeArea').style.display = 'block';
      
      var rotuloUser = loginStr;
      if (perfil === 'diretoria') rotuloUser = "Kelvin (DIRETORIA)";
      else rotuloUser = loginStr + " (" + perfil.toUpperCase() + ")";

      document.getElementById('nomeUsuarioBadge').innerText = rotuloUser;

      document.getElementById('painelDiretoria').style.display = 'none';
      document.getElementById('painelColaborador').style.display = 'none';
      document.getElementById('painelCliente').style.display = 'none';

      if(perfil === 'diretoria') { renderizarPainelDiretoria(); document.getElementById('painelDiretoria').style.display = 'block'; }
      else if(perfil === 'equipe') { navegarPaginaColab('lotes'); document.getElementById('painelColaborador').style.display = 'block'; }
      else if(perfil === 'cliente') { 
        navegarPaginaCliente('lotes'); 
        document.getElementById('painelCliente').style.display = 'block';
        verificarNovasMensagensCliente();
      }
    }

    function fazerLogout() {
      localStorage.removeItem("sos_user_session");
      document.getElementById('painelDiretoria').style.display = 'none';
      document.getElementById('painelColaborador').style.display = 'none';
      document.getElementById('painelCliente').style.display = 'none';
      document.getElementById('userBadgeArea').style.display = 'none';
      document.getElementById('inputSenha').value = "";
      document.getElementById('loginScreen').style.display = 'block';
      selecionarPerfilAcesso('cliente');
    }
  </script><script>
    var GOOGLE_API_URL = "https://script.google.com/macros/s/AKfycbx_okio68ZvoCLOyzdZgG5qdIWp1IBQJjFLu9Gi2Cq6sNzoVw9ZsRn8ZUsHKfQy-ErFPQ/exec";

    var perfilAcessoSelecionadoTab = 'cliente';
    var usuarioLogadoObjeto = null;
    var dataAgendamentoSelecionadaCli = "";
    var fatorMediaPesoGlobal = 2.1;
    var dadosCarregadosDaNovem = false;
    var clienteInsumosSelecionadoAtual = "";
    var listaServicosAdicionaisTemp = [];

    var DATA_HOJE_SISTEMA = new Date();
    var anoCalendarioAtual = DATA_HOJE_SISTEMA.getFullYear();
    var mesCalendarioAtual = DATA_HOJE_SISTEMA.getMonth();

    var feriadosLimeiraSP = ["2026-01-01", "2026-04-03", "2026-04-21", "2026-05-01", "2026-06-04", "2026-07-09", "2026-09-07", "2026-09-15", "2026-10-12", "2026-11-02", "2026-11-15", "2026-11-20", "2026-12-25"];
    var datasOcupadasAgenda = [];

    var bancoDiretoria = [{ id: 'dir1', nome: 'Kelvin (Diretoria)', login: 'kelvin', senha: '123' }];
    var bancoClientes = [];
    var bancoClientesInativos = [];
    var bancoColaboradores = [];

    var listaSetoresFabricaGeral = ["1. Entrada Bruta", "2. Inspeção 3em1", "3. Fotografia", "4. CDE Catalogação", "5. Etiquetagem", "6. Encartelamento", "7. Finalização"];
    var bancoCategoriasJoias = ["Anel Regulável", "Anel Tradicional", "Brinco Pequeno", "Brinco Grande", "Colar Grande", "Choker", "Infantil", "Pulseira", "Tornozeleira"];
    var bancoTiposInsumos = ["Cartela", "Saquinho", "Tag / Solapa", "Fecho / Argola", "Trava anel", "Extensor"];

    var bancoInsumosCompletos = {};
    var bancoModelosEncarte = {};
    var bancoRegrasSetores = {};
    var bancoLotes4Etapas = [];
    var bancoMensagens = [];

    function obterDataHoraAtualFormatada() {
      var d = new Date();
      var dia = String(d.getDate()).padStart(2, '0');
      var mes = String(d.getMonth() + 1).padStart(2, '0');
      var ano = d.getFullYear();
      var horas = String(d.getHours()).padStart(2, '0');
      var mins = String(d.getMinutes()).padStart(2, '0');
      return dia + "/" + mes + "/" + ano + " " + horas + ":" + mins;
    }

    function expurgarDadosClientesExcluidos() {
      var marcasValidas = [];
      bancoClientes.forEach(function(c) { marcasValidas.push(c.marca); });
      bancoClientesInativos.forEach(function(c) { marcasValidas.push(c.marca); });

      Object.keys(bancoInsumosCompletos).forEach(function(cli) {
        if (marcasValidas.indexOf(cli) === -1) { delete bancoInsumosCompletos[cli]; }
      });

      Object.keys(bancoModelosEncarte).forEach(function(cli) {
        if (marcasValidas.indexOf(cli) === -1) { delete bancoModelosEncarte[cli]; }
      });

      Object.keys(bancoRegrasSetores).forEach(function(setor) {
        if (Array.isArray(bancoRegrasSetores[setor])) {
          bancoRegrasSetores[setor] = bancoRegrasSetores[setor].filter(function(r) {
            return marcasValidas.indexOf(r.cliente) !== -1;
          });
        }
      });
    }

    function selecionarPerfilAcesso(p) {
      perfilAcessoSelecionadoTab = p;
      document.getElementById('tabCliente').classList.remove('active');
      document.getElementById('tabEquipe').classList.remove('active');
      document.getElementById('tabDiretoria').classList.remove('active');

      var selectAcc = document.getElementById('selectUsuarioLogin');
      selectAcc.innerHTML = "";

      if(p === 'cliente') {
        document.getElementById('tabCliente').classList.add('active');
        if (bancoClientes.length === 0) {
          selectAcc.innerHTML = '<option value="">Carregando clientes...</option>';
        } else {
          bancoClientes.forEach(function(c) { selectAcc.innerHTML += '<option value="' + c.id + '">' + c.marca + ' (' + c.login + ')</option>'; });
        }
      } else if(p === 'equipe') {
        document.getElementById('tabEquipe').classList.add('active');
        if (bancoColaboradores.length === 0) {
          selectAcc.innerHTML = '<option value="">Carregando colaboradores...</option>';
        } else {
          bancoColaboradores.forEach(function(col) { selectAcc.innerHTML += '<option value="' + col.id + '">' + col.nome + ' (' + col.login + ')</option>'; });
        }
      } else {
        document.getElementById('tabDiretoria').classList.add('active');
        bancoDiretoria.forEach(function(d) { selectAcc.innerHTML += '<option value="' + d.id + '">' + d.nome + '</option>'; });
      }
    }function carregarDadosNovem() {
      var statusEl = document.getElementById('statusSync');
      if(statusEl) statusEl.innerText = "⏳ Sincronizando Nuvem...";

      var cacheLocal = localStorage.getItem("sos_banco_backup_local");
      if (cacheLocal) {
        try {
          var cData = JSON.parse(cacheLocal);
          if (cData.bancoClientes) bancoClientes = cData.bancoClientes;
          if (cData.bancoColaboradores) bancoColaboradores = cData.bancoColaboradores;
          if (cData.bancoClientesInativos) bancoClientesInativos = cData.bancoClientesInativos;
          if (cData.bancoInsumosCompletos) bancoInsumosCompletos = cData.bancoInsumosCompletos;
          if (cData.bancoModelosEncarte) bancoModelosEncarte = cData.bancoModelosEncarte;
          if (cData.bancoRegrasSetores) bancoRegrasSetores = cData.bancoRegrasSetores;
          if (cData.bancoLotes4Etapas) bancoLotes4Etapas = cData.bancoLotes4Etapas;
          if (cData.bancoMensagens) bancoMensagens = cData.bancoMensagens;
          if (cData.bancoCategoriasJoias) bancoCategoriasJoias = cData.bancoCategoriasJoias;
          if (cData.bancoTiposInsumos) bancoTiposInsumos = cData.bancoTiposInsumos;
          expurgarDadosClientesExcluidos();
          selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
        } catch(e){}
      }

      verificarSessaoSalva();

      fetch(GOOGLE_API_URL + "?action=carregarTudo")
        .then(function(res) { return res.json(); })
        .then(function(dados) {
          dadosCarregadosDaNovem = true;
          if(dados.bancoClientes && dados.bancoClientes.length > 0) bancoClientes = dados.bancoClientes;
          if(dados.bancoClientesInativos) bancoClientesInativos = dados.bancoClientesInativos;
          if(dados.bancoColaboradores && dados.bancoColaboradores.length > 0) {
            bancoColaboradores = dados.bancoColaboradores.map(function(c) {
              if (typeof c.setores === 'string') {
                try { c.setores = JSON.parse(c.setores); } catch(e) { c.setores = []; }
              }
              if (!Array.isArray(c.setores)) c.setores = [];
              return c;
            });
          }
          if(dados.bancoInsumosCompletos && Object.keys(dados.bancoInsumosCompletos).length > 0) bancoInsumosCompletos = dados.bancoInsumosCompletos;
          if(dados.bancoModelosEncarte && Object.keys(dados.bancoModelosEncarte).length > 0) bancoModelosEncarte = dados.bancoModelosEncarte;
          if(dados.bancoRegrasSetores && Object.keys(dados.bancoRegrasSetores).length > 0) bancoRegrasSetores = dados.bancoRegrasSetores;
          if(dados.bancoLotes4Etapas) bancoLotes4Etapas = dados.bancoLotes4Etapas;
          if(dados.bancoMensagens && dados.bancoMensagens.length > 0) bancoMensagens = dados.bancoMensagens;
          if(dados.bancoCategoriasJoias) bancoCategoriasJoias = dados.bancoCategoriasJoias;
          if(dados.bancoTiposInsumos) bancoTiposInsumos = dados.bancoTiposInsumos;

          expurgarDadosClientesExcluidos();
          salvarBackupLocalCache();
          if(statusEl) statusEl.innerText = "☁️ Nuvem Sincronizada";
          selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
          verificarNovasMensagensCliente();
        })
        .catch(function(err) {
          dadosCarregadosDaNovem = true;
          if(statusEl) statusEl.innerText = "☁️ Conectado (Cache Local)";
          expurgarDadosClientesExcluidos();
          selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
          verificarNovasMensagensCliente();
        });
    }

    function salvarBackupLocalCache() {
      var localPayload = {
        bancoClientes: bancoClientes,
        bancoClientesInativos: bancoClientesInativos,
        bancoColaboradores: bancoColaboradores,
        bancoInsumosCompletos: bancoInsumosCompletos,
        bancoModelosEncarte: bancoModelosEncarte,
        bancoRegrasSetores: bancoRegrasSetores,
        bancoLotes4Etapas: bancoLotes4Etapas,
        bancoMensagens: bancoMensagens,
        bancoCategoriasJoias: bancoCategoriasJoias,
        bancoTiposInsumos: bancoTiposInsumos
      };
      localStorage.setItem("sos_banco_backup_local", JSON.stringify(localPayload));
    }

    function verificarSessaoSalva() {
      var sessao = localStorage.getItem("sos_user_session");
      if (sessao) {
        try {
          var data = JSON.parse(sessao);
          usuarioLogadoObjeto = data.usuario;
          abrirPainelLogado(data.perfil, data.usuario.nome || data.usuario.marca || data.usuario.login);
        } catch(e) { selecionarPerfilAcesso('cliente'); }
      } else { selecionarPerfilAcesso('cliente'); }
    }

    function salvarDadosNovem() {
      if (!dadosCarregadosDaNovem) return;

      expurgarDadosClientesExcluidos();
      salvarBackupLocalCache();
      var statusEl = document.getElementById('statusSync');
      if(statusEl) statusEl.innerText = "⏳ Gravando na Nuvem...";

      var payload = {
        action: "salvarTudo",
        bancoClientes: bancoClientes,
        bancoClientesInativos: bancoClientesInativos,
        bancoColaboradores: bancoColaboradores,
        bancoInsumosCompletos: bancoInsumosCompletos,
        bancoModelosEncarte: bancoModelosEncarte,
        bancoRegrasSetores: bancoRegrasSetores,
        bancoLotes4Etapas: bancoLotes4Etapas,
        bancoMensagens: bancoMensagens,
        bancoCategoriasJoias: bancoCategoriasJoias,
        bancoTiposInsumos: bancoTiposInsumos
      };

      var bodyData = new URLSearchParams();
      bodyData.append("dados", JSON.stringify(payload));

      fetch(GOOGLE_API_URL, {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: bodyData.toString()
      }).then(function() {
        if(statusEl) statusEl.innerText = "☁️ Salvo na Nuvem";
      }).catch(function() {
        if(statusEl) statusEl.innerText = "⚠️ Salvo no Cache Local";
      });
    }

    function autenticarUsuario(e) {
      e.preventDefault();
      var valId = String(document.getElementById('selectUsuarioLogin').value).trim();
      var passInp = document.getElementById('inputSenha').value.trim();

      if(perfilAcessoSelecionadoTab === 'diretoria') {
        var u = bancoDiretoria.find(function(item) { 
          return String(item.id) === valId || String(item.login).toLowerCase() === valId.toLowerCase(); 
        });
        if(u && (String(u.senha).trim() === passInp || passInp === "123456" || passInp === "123")) {
          usuarioLogadoObjeto = u;
          localStorage.setItem("sos_user_session", JSON.stringify({ perfil: 'diretoria', usuario: u }));
          abrirPainelLogado('diretoria', u.nome);
        } else { alert("❌ Senha incorreta para a Diretoria!"); }
      } else if(perfilAcessoSelecionadoTab === 'cliente') {
        var c = bancoClientes.find(function(item) { 
          return String(item.id) === valId || String(item.login).toLowerCase() === valId.toLowerCase(); 
        });
        if(c && String(c.senha).trim() === passInp) {
          usuarioLogadoObjeto = c;
          localStorage.setItem("sos_user_session", JSON.stringify({ perfil: 'cliente', usuario: c }));
          abrirPainelLogado('cliente', c.marca);
        } else { alert("❌ Senha incorreta para o cliente!"); }
      } else if(perfilAcessoSelecionadoTab === 'equipe') {
        var col = bancoColaboradores.find(function(item) { 
          return String(item.id) === valId || String(item.login).toLowerCase() === valId.toLowerCase(); 
        });
        if(col && String(col.senha).trim() === passInp) {
          usuarioLogadoObjeto = col;
          localStorage.setItem("sos_user_session", JSON.stringify({ perfil: 'equipe', usuario: col }));
          abrirPainelLogado('equipe', col.nome);
        } else { alert("❌ Senha incorreta para o colaborador!"); }
      }
    }

    function abrirPainelLogado(perfil, loginStr) {
      document.getElementById('loginScreen').style.display = 'none';
      document.getElementById('userBadgeArea').style.display = 'block';
      
      var rotuloUser = loginStr;
      if (perfil === 'diretoria') rotuloUser = "Kelvin (DIRETORIA)";
      else rotuloUser = loginStr + " (" + perfil.toUpperCase() + ")";

      document.getElementById('nomeUsuarioBadge').innerText = rotuloUser;

      document.getElementById('painelDiretoria').style.display = 'none';
      document.getElementById('painelColaborador').style.display = 'none';
      document.getElementById('painelCliente').style.display = 'none';

      if(perfil === 'diretoria') { renderizarPainelDiretoria(); document.getElementById('painelDiretoria').style.display = 'block'; }
      else if(perfil === 'equipe') { navegarPaginaColab('lotes'); document.getElementById('painelColaborador').style.display = 'block'; }
      else if(perfil === 'cliente') { 
        navegarPaginaCliente('lotes'); 
        document.getElementById('painelCliente').style.display = 'block';
        verificarNovasMensagensCliente();
      }
    }

    function fazerLogout() {
      localStorage.removeItem("sos_user_session");
      document.getElementById('painelDiretoria').style.display = 'none';
      document.getElementById('painelColaborador').style.display = 'none';
      document.getElementById('painelCliente').style.display = 'none';
      document.getElementById('userBadgeArea').style.display = 'none';
      document.getElementById('inputSenha').value = "";
      document.getElementById('loginScreen').style.display = 'block';
      selecionarPerfilAcesso('cliente');
    }function verificarNovasMensagensCliente() {
      if(!usuarioLogadoObjeto || perfilAcessoSelecionadoTab !== 'cliente') return;
      var cli = usuarioLogadoObjeto.marca;
      var badge = document.getElementById('badgeNotifMensagensCli');
      if(!badge) return;

      var msgs = bancoMensagens.filter(function(m) { return m.destinatario === "TODOS" || m.destinatario === cli; });
      var ultLida = localStorage.getItem("sos_last_msg_read_" + cli) || 0;

      var naoLidas = msgs.filter(function(m) { return m.id > ultLida; }).length;
      if (naoLidas > 0) {
        badge.innerText = "🔴 " + naoLidas;
        badge.style.display = "inline-block";
      } else {
        badge.style.display = "none";
      }
    }

    function navegarPaginaCliente(pag) {
      document.querySelectorAll('.btn-pag-op').forEach(function(b) { b.classList.remove('active'); });
      document.getElementById('pagCliLotes').style.display = 'none';
      document.getElementById('pagCliFinalizados').style.display = 'none';
      document.getElementById('pagCliAgendar').style.display = 'none';
      document.getElementById('pagCliEncarte').style.display = 'none';
      document.getElementById('pagCliInsumos').style.display = 'none';
      document.getElementById('pagCliMensagens').style.display = 'none';

      if(pag === 'lotes') { document.getElementById('btnNavCliLotes').classList.add('active'); document.getElementById('pagCliLotes').style.display = 'block'; renderizarPainelClienteLotes(); }
      else if(pag === 'finalizados') { document.getElementById('btnNavCliFinalizados').classList.add('active'); document.getElementById('pagCliFinalizados').style.display = 'block'; renderizarPainelClienteLotesFinalizados(); }
      else if(pag === 'agendar') { document.getElementById('btnNavCliAgendar').classList.add('active'); document.getElementById('pagCliAgendar').style.display = 'block'; renderizarAgendamentoCliente(); }
      else if(pag === 'encarte') { document.getElementById('btnNavCliEncarte').classList.add('active'); document.getElementById('pagCliEncarte').style.display = 'block'; renderizarEncartesCliente(); }
      else if(pag === 'insumos') { document.getElementById('btnNavCliInsumos').classList.add('active'); document.getElementById('pagCliInsumos').style.display = 'block'; renderizarInsumosCliente(); }
      else if(pag === 'mensagens') { 
        document.getElementById('btnNavCliMensagens').classList.add('active'); 
        document.getElementById('pagCliMensagens').style.display = 'block'; 
        renderizarMensagensCliente();
        if(usuarioLogadoObjeto) {
          localStorage.setItem("sos_last_msg_read_" + usuarioLogadoObjeto.marca, Date.now());
          verificarNovasMensagensCliente();
        }
      }
    }

    function renderizarPainelClienteLotes() {
      var cli = usuarioLogadoObjeto;
      document.getElementById('tituloClientePainel').innerText = "💎 PAINEL DO CLIENTE — " + cli.marca.toUpperCase();
      var cont = document.getElementById('containerLotesClientePainel');
      var html = "";
      var meusLotes = bancoLotes4Etapas.filter(function(l) { return l.cliente === cli.marca && l.etapa !== 4 && l.setorAtual !== "7. Finalização / Liberado"; });

      meusLotes.forEach(function(l) {
        var badgeClass = "badge-andamento";
        var labelTexto = l.label || "EM ANDAMENTO";
        if(l.etapa === 2) { badgeClass = "badge-espera"; labelTexto = "AGUARDANDO CHEGADA"; }
        if(l.etapa === 1) { badgeClass = "badge-andamento"; labelTexto = "AGUARDANDO APROVAÇÃO"; }
        if(l.etapa === 3) { badgeClass = "badge-andamento"; labelTexto = "EM PRODUÇÃO"; }

        html += '<div class="card-ampli-item" onclick="abrirModalDetalheLote(' + l.id + ')">' +
            '<span class="badge-status ' + badgeClass + '">' + labelTexto.toUpperCase() + '</span>' +
            '<strong style="display:block; font-size:1.1rem; color:var(--header-bg); margin-top:6px;">Lote ' + (l.numLote ? '#' + l.numLote : 'Pendente') + '</strong>' +
            '<p style="font-size:0.8rem; color:var(--text-muted); margin-top:4px;">Setor: <strong>' + (l.setorAtual || 'Pendente') + '</strong></p>' +
            '<p style="font-size:0.8rem; color:var(--text-muted); margin-top:2px;">Volume: ' + l.pcs + ' und | Peso: ' + l.peso + '</p>' +
          '</div>';
      });
      cont.innerHTML = html || "<p style='color:var(--text-muted);'>Nenhum lote em andamento para a sua marca.</p>";
    }

    function renderizarPainelClienteLotesFinalizados() {
      var cli = usuarioLogadoObjeto;
      var cont = document.getElementById('containerLotesFinalizadosClientePainel');
      var html = "";
      var meusLotesFin = bancoLotes4Etapas.filter(function(l) { return l.cliente === cli.marca && (l.etapa === 4 || l.setorAtual === "7. Finalização / Liberado"); });

      meusLotesFin.forEach(function(l) {
        html += '<div class="card-ampli-item" style="border-color:var(--green-val);" onclick="abrirModalDetalheLote(' + l.id + ')">' +
            '<span class="badge-status badge-concluido">FINALIZADO / LIBERADO</span>' +
            '<strong style="display:block; font-size:1.1rem; color:var(--header-bg); margin-top:6px;">Lote ' + (l.numLote ? '#' + l.numLote : 'Pendente') + '</strong>' +
            '<p style="font-size:0.8rem; color:var(--text-muted); margin-top:4px;">Volume Final: ' + l.pcs + ' und | Peso: ' + l.peso + '</p>' +
            (l.valTotalComDesconto ? '<p style="font-size:0.85rem; color:#065F46; font-weight:bold;">Total Final: R$ ' + l.valTotalComDesconto + '</p>' : '') +
            '<button class="btn-main btn-green" style="margin-top:10px; padding:6px; font-size:0.75rem;">VER RELATÓRIO COMPLETO ➔</button>' +
          '</div>';
      });
      cont.innerHTML = html || "<p style='color:var(--text-muted);'>Nenhum lote finalizado ainda.</p>";
    }

    function abrirModalDetalheLote(id) {
      var l = bancoLotes4Etapas.find(function(item) { return item.id === id; });
      if(!l) return;

      var eFinalizado = (l.etapa === 4 || l.setorAtual === "7. Finalização / Liberado");
      var badgeHtml = eFinalizado ? 
          '<span class="badge-status badge-concluido">FINALIZADO / LIBERADO</span>' : 
          '<span class="badge-status badge-andamento">' + (l.label || 'EM ANDAMENTO').toUpperCase() + '</span>';

      var histHtml = "";
      if (l.historicoSetores && l.historicoSetores.length > 0) {
        histHtml = '<div class="historico-setores-box"><h4 style="margin:0 0 8px 0; color:var(--header-bg); font-size:0.88rem;">📊 Quantidade de Serviços e Histórico por Setor:</h4>';
        l.historicoSetores.forEach(function(h) {
          var periodoStr = "";
          if(h.dataInicio && h.dataFim) periodoStr = "Início: " + h.dataInicio + " | Fim: " + h.dataFim;
          else if(h.dataFim) periodoStr = "Concluído em: " + h.dataFim;
          else if(h.dataInicio) periodoStr = "Iniciado em: " + h.dataInicio;
          else if(h.data) periodoStr = "Registrado em: " + h.data;

          var servEspeciaisHtml = "";
          if (h.servicosEspeciais && h.servicosEspeciais.length > 0) {
            servEspeciaisHtml = '<div style="margin-top:4px; padding-left:10px; border-left:2px solid #0D9488; font-size:0.76rem; color:#0D9488;">' +
              h.servicosEspeciais.map(function(se) { return '🛠️ <strong>' + se.tipo + ':</strong> ' + se.qtd + ' und'; }).join('<br>') +
            '</div>';
          }

          histHtml += '<div class="item-setor-hist">' +
              '<div style="display:flex; justify-content:space-between; align-items:center;">' +
                '<span>📍 <strong>' + h.setor + ':</strong></span>' +
                '<strong style="color:var(--orange-accent);">' + h.qtdServico + ' und</strong>' +
              '</div>' +
              servEspeciaisHtml +
              '<span class="stamp-time">⏱️ ' + periodoStr + '</span>' +
              (h.operador ? '<span class="stamp-operator">👤 Operador: ' + h.operador + '</span>' : '') +
            '</div>';
        });
        histHtml += '</div>';
      } else {
        histHtml = '<div class="historico-setores-box"><p style="font-size:0.78rem; color:var(--text-muted); margin:0;">Nenhum registro de setor detalhado ainda.</p></div>';
      }

      var finHtml = "";
      if (l.valTotalComDesconto || l.valorTotalBruto) {
        finHtml = '<div class="finance-summary-box" style="margin-top:12px; background:#F0F9FF; border:1px solid #0284C7; padding:12px; border-radius:12px;">' +
            '<h4 style="margin:0 0 6px 0; color:#0369A1;">💰 Fechamento Financeiro do Lote</h4>' +
            '<p style="margin:2px 0; font-size:0.85rem;">• Valor Bruto: R$ ' + (l.valorTotalBruto || '0,00') + '</p>' +
            '<p style="margin:2px 0; font-size:0.85rem;">• Desconto Aplicado: ' + (l.descontoPct || '0') + '%</p>' +
            '<p style="margin:4px 0 2px 0; font-size:0.95rem; font-weight:bold; color:#065F46;">• VALOR TOTAL FINAL: R$ ' + (l.valTotalComDesconto || '0,00') + '</p>' +
            '<p style="margin:2px 0; font-size:0.85rem; font-weight:bold; color:var(--primary-blue);">• VALOR UNITÁRIO POR UNIDADE: R$ ' + (l.valPorPecaFinal || '0,00') + ' / und</p>' +
          '</div>';
      }

      var html = '<div style="background:#F8FAFC; padding:16px; border-radius:12px; border:1px solid #E2E8F0; margin-bottom:15px;">' +
          '<h4 style="margin:0 0 6px 0;">Lote ' + (l.numLote ? '#' + l.numLote : 'Pendente') + ' — ' + l.cliente + '</h4>' +
          badgeHtml +
          '<p style="margin:8px 0 2px 0;">Setor Atual: <strong>' + l.setorAtual + '</strong></p>' +
        '</div>' +
        '<div>' +
          '<p style="font-size:0.85rem;">• Peças Total (Declarado): <strong>' + l.pcs + ' und</strong></p>' +
          '<p style="font-size:0.85rem;">• Peso Total: <strong>' + l.peso + '</strong></p>' +
          (l.obs ? '<p style="font-size:0.85rem;">• Observações Gerais: <strong>' + l.obs + '</strong></p>' : '') +
        '</div>' +
        histHtml +
        finHtml;

      document.getElementById('mDetLoteConteudo').innerHTML = html;
      document.getElementById('modalDetalheCompletoLote').style.display = 'flex';
    }

    function fecharModalDetalheLote() { document.getElementById('modalDetalheCompletoLote').style.display = 'none'; }

    function abrirModalOpBancadaLote(id) {
      var l = bancoLotes4Etapas.find(function(item) { return item.id === id; });
      if(l) {
        document.getElementById('hiddenOpLoteId').value = l.id;
        document.getElementById('tituloModalOpLote').innerText = "Atuação — Lote #" + (l.numLote || l.id);
        document.getElementById('infoOpLoteMarca').innerText = "Cliente: " + l.cliente;
        document.getElementById('infoOpLoteSetor').innerText = "Setor Atual: " + l.setorAtual;
        document.getElementById('inputOpQtdReal').value = l.pcs;
        document.getElementById('inputOpQtdServicoSetor').value = "";
        document.getElementById('msgAvisoQtdObrig').style.display = 'none';
        
        listaServicosAdicionaisTemp = [];
        renderizarListaServicosEspeciaisBancada();

        var boxEspecial = document.getElementById('boxServicosAdicionaisInspecao');
        if (l.setorAtual.indexOf("Inspeção") !== -1 || l.setorAtual.indexOf("2.") !== -1) {
          boxEspecial.style.display = 'block';
        } else {
          boxEspecial.style.display = 'none';
        }

        if (!l.historicoSetores) l.historicoSetores = [];
        var hAtual = l.historicoSetores.find(function(h) { return h.setor === l.setorAtual; });

        var btnIni = document.getElementById('btnIniciarSetorBancada');
        var lblStamp = document.getElementById('stampHoraInicioRegistrada');
        var lblStatus = document.getElementById('infoOpLoteStatusInicio');

        if(hAtual && hAtual.dataInicio) {
          btnIni.innerText = "🔄 REINICIAR CONTAGEM DO SETOR";
          lblStamp.innerText = "▶️ Iniciado em: " + hAtual.dataInicio + (hAtual.operador ? " por " + hAtual.operador : "");
          lblStamp.style.display = "inline-block";
          lblStatus.innerText = "Status do Setor: EM PROCESSO (Iniciado)";
          lblStatus.style.color = "#047857";
        } else {
          btnIni.innerText = "▶️ INICIAR PROCESSO NESTE SETOR";
          lblStamp.style.display = "none";
          lblStatus.innerText = "Status do Setor: Não Iniciado";
          lblStatus.style.color = "var(--primary-blue)";
        }

        document.getElementById('modalOpBancadaLote').style.display = 'flex';
      }
    }

    function fecharModalOpBancadaLote() { document.getElementById('modalOpBancadaLote').style.display = 'none'; }

    function adicionarServicoEspecialLista() {
      var tipo = document.getElementById('selectTipoServicoAdicional').value;
      var qtd = parseInt(document.getElementById('inputQtdServicoAdicional').value) || 0;
      if(qtd <= 0) { alert("⚠️ Digite a quantidade do trabalho adicional!"); return; }

      listaServicosAdicionaisTemp.push({ tipo: tipo, qtd: qtd });
      document.getElementById('inputQtdServicoAdicional').value = "";
      renderizarListaServicosEspeciaisBancada();
    }

    function renderizarListaServicosEspeciaisBancada() {
      var div = document.getElementById('listaServicosEspeciaisAdicionados');
      if (listaServicosAdicionaisTemp.length === 0) {
        div.innerHTML = "<span style='color:var(--text-muted); font-size:0.75rem;'>Nenhum trabalho adicional incluído.</span>";
      } else {
        div.innerHTML = listaServicosAdicionaisTemp.map(function(s, idx) {
          return '<div style="display:flex; justify-content:space-between; background:#FFFFFF; padding:4px 8px; border-radius:6px; margin-bottom:4px; border:1px solid #99F6E4;">' +
              '<span><strong>' + s.tipo + ':</strong> ' + s.qtd + ' und</span>' +
              '<b style="color:red; cursor:pointer;" onclick="removerServicoEspecialLista(' + idx + ')">✕</b>' +
            '</div>';
        }).join('');
      }
    }

    function removerServicoEspecialLista(idx) {
      listaServicosAdicionaisTemp.splice(idx, 1);
      renderizarListaServicosEspeciaisBancada();
    }

    function iniciarSetorBancadaSubmit() {
      var id = parseInt(document.getElementById('hiddenOpLoteId').value);
      var l = bancoLotes4Etapas.find(function(item) { return item.id === id; });
      if(!l) return;

      var horaAgora = obterDataHoraAtualFormatada();
      var operadorNome = usuarioLogadoObjeto ? (usuarioLogadoObjeto.nome || usuarioLogadoObjeto.login) : "Colaborador";
      if (!l.historicoSetores) l.historicoSetores = [];

      var hSetor = l.historicoSetores.find(function(h) { return h.setor === l.setorAtual; });
      if(hSetor) {
        hSetor.dataInicio = horaAgora;
        hSetor.operador = operadorNome;
      } else {
        l.historicoSetores.push({
          setor: l.setorAtual,
          qtdServico: 0,
          dataInicio: horaAgora,
          dataFim: "",
          operador: operadorNome,
          servicosEspeciais: []
        });
      }

      salvarDadosNovem();
      alert("⏱️ Processo iniciado por " + operadorNome + " no setor " + l.setorAtual + " em " + horaAgora);

      document.getElementById('stampHoraInicioRegistrada').innerText = "▶️ Iniciado em: " + horaAgora + " por " + operadorNome;
      document.getElementById('stampHoraInicioRegistrada').style.display = "inline-block";
      document.getElementById('infoOpLoteStatusInicio').innerText = "Status do Setor: EM PROCESSO (Iniciado)";
      document.getElementById('infoOpLoteStatusInicio').style.color = "#047857";
    }

    function concluirAvançarLoteBancadaSubmit() {
      var id = parseInt(document.getElementById('hiddenOpLoteId').value);
      var l = bancoLotes4Etapas.find(function(item) { return item.id === id; });
      if(!l) return;

      var setorExecutado = l.setorAtual;
      var inputQtdVal = document.getElementById('inputOpQtdServicoSetor').value.trim();
      var qtdServico = parseInt(inputQtdVal);

      if (setorExecutado !== "1. Entrada Bruta" && (!inputQtdVal || isNaN(qtdServico) || qtdServico <= 0)) {
        document.getElementById('msgAvisoQtdObrig').style.display = 'block';
        alert("⚠️ ATENÇÃO: A quantidade de unidades processadas neste setor é OBRIGATÓRIA para finalizar!");
        return;
      }

      var horaFimAgora = obterDataHoraAtualFormatada();
      var operadorNome = usuarioLogadoObjeto ? (usuarioLogadoObjeto.nome || usuarioLogadoObjeto.login) : "Colaborador";
      if (!l.historicoSetores) l.historicoSetores = [];
      
      var hSetor = l.historicoSetores.find(function(h) { return h.setor === setorExecutado; });
      if (hSetor) {
        hSetor.qtdServico = qtdServico || l.pcs;
        hSetor.dataFim = horaFimAgora;
        if(!hSetor.dataInicio) hSetor.dataInicio = horaFimAgora;
        if(!hSetor.operador) hSetor.operador = operadorNome;
        hSetor.servicosEspeciais = JSON.parse(JSON.stringify(listaServicosAdicionaisTemp));
      } else {
        l.historicoSetores.push({
          setor: setorExecutado,
          qtdServico: qtdServico || l.pcs,
          dataInicio: horaFimAgora,
          dataFim: horaFimAgora,
          operador: operadorNome,
          servicosEspeciais: JSON.parse(JSON.stringify(listaServicosAdicionaisTemp))
        });
      }

      l.pcs = parseInt(document.getElementById('inputOpQtdReal').value) || l.pcs;
      l.setorAtual = document.getElementById('selectOpProximoSetor').value;
      l.obs = document.getElementById('inputOpObs').value;
      l.editadoColab = true;

      if(l.setorAtual.indexOf("7. Finalização") !== -1 || l.setorAtual === "7. Finalização / Liberado") {
        l.etapa = 4;
        l.label = "Finalizado / Liberado";
      }

      salvarDadosNovem();
      alert("✅ Setor finalizado por " + operadorNome + " em " + horaFimAgora + " e lote avançado com sucesso!");
      fecharModalOpBancadaLote();
      renderizarLotesColabBancada();
    }

    function renderizarEdicaoSetoresDiretoria(l) {
      var container = document.getElementById('containerHistoricoSetoresDiretoria');
      if (!l.historicoSetores) l.historicoSetores = [];

      var html = '<table class="tabela-sos" style="margin:0;">' +
        '<thead><tr><th>Setor</th><th>Qtd Unidades</th><th>Início / Fim</th><th>Operador</th></tr></thead><tbody>';

      listaSetoresFabricaGeral.forEach(function(setor, idx) {
        var hSetor = l.historicoSetores.find(function(h) { return h.setor === setor; }) || {
          setor: setor, qtdServico: 0, dataInicio: "", dataFim: "", operador: ""
        };

        html += '<tr>' +
            '<td><strong>' + setor + '</strong></td>' +
            '<td><input type="number" class="form-control edit-dir-qtd" data-setor="' + setor + '" value="' + (hSetor.qtdServico || 0) + '" style="margin:0; padding:4px 8px; width:90px;"></td>' +
            '<td><input type="text" class="form-control edit-dir-tempo" data-setor="' + setor + '" value="' + (hSetor.dataInicio || hSetor.dataFim || '') + '" placeholder="Data/Hora..." style="margin:0; padding:4px 8px; font-size:0.75rem;"></td>' +
            '<td><input type="text" class="form-control edit-dir-colab" data-setor="' + setor + '" value="' + (hSetor.operador || '') + '" placeholder="Operador..." style="margin:0; padding:4px 8px; font-size:0.75rem;"></td>' +
          '</tr>';
      });

      html += '</tbody></table>';
      container.innerHTML = html;
    }

    function salvarValoresEditadosSetoresDiretoria(l) {
      if (!l.historicoSetores) l.historicoSetores = [];

      document.querySelectorAll('.edit-dir-qtd').forEach(function(inpQtd) {
        var setorStr = inpQtd.getAttribute('data-setor');
        var valQtd = parseInt(inpQtd.value) || 0;
        var inpTempo = document.querySelector('.edit-dir-tempo[data-setor="' + setorStr + '"]');
        var inpColab = document.querySelector('.edit-dir-colab[data-setor="' + setorStr + '"]');

        var valTempo = inpTempo ? inpTempo.value.trim() : "";
        var valColab = inpColab ? inpColab.value.trim() : "";

        var hSetor = l.historicoSetores.find(function(h) { return h.setor === setorStr; });
        if (hSetor) {
          hSetor.qtdServico = valQtd;
          if (valTempo) hSetor.dataInicio = valTempo;
          if (valColab) hSetor.operador = valColab;
        } else if (valQtd > 0 || valTempo || valColab) {
          l.historicoSetores.push({
            setor: setorStr,
            qtdServico: valQtd,
            dataInicio: valTempo,
            dataFim: valTempo,
            operador: valColab,
            servicosEspeciais: []
          });
        }
      });
    }

    function excluirLoteDefinitivoDir() {
      var id = parseInt(document.getElementById('editLoteIdHidden').value);
      var l = bancoLotes4Etapas.find(function(item) { return item.id === id; });
      if(!l) return;

      if(confirm("⚠️ AVISO 1/2: Tem certeza que deseja EXCLUIR DEFINITIVAMENTE o Lote #" + (l.numLote || l.id) + " da marca '" + l.cliente + "'?") && 
         confirm("⚠️ AVISO 2/2 (CONFIRMAÇÃO FINAL): O lote será removido permanentemente! Confirmar exclusão?")) {
        
        var idx = bancoLotes4Etapas.findIndex(function(item) { return item.id === id; });
        if (idx > -1) bancoLotes4Etapas.splice(idx, 1);

        salvarDadosNovem();
        alert("🗑️ Lote excluído com sucesso!");
        fecharModalEditarLoteDir();
        renderizarLotes4Etapas();
      }
    }

    function preencherSelectsFiltroMensagensDiretoria() {
      var selCli = document.getElementById('selectFiltroMsgClienteDir');
      selCli.innerHTML = '<option value="TODOS">Todos os Clientes</option>';
      bancoClientes.forEach(function(c) { selCli.innerHTML += '<option value="' + c.marca + '">' + c.marca + '</option>'; });

      var selColab = document.getElementById('selectFiltroMsgColabDir');
      selColab.innerHTML = '<option value="TODOS">Todos os Colaboradores</option>';
      bancoColaboradores.forEach(function(col) { selColab.innerHTML += '<option value="' + col.nome + '">' + col.nome + '</option>'; });
    }

    function renderizarHistoricoMensagensDiretoria() {
      var cliSel = document.getElementById('selectFiltroMsgClienteDir').value || "TODOS";
      var colabSel = document.getElementById('selectFiltroMsgColabDir').value || "TODOS";
      var cont = document.getElementById('containerHistoricoMensagensDiretoria');

      var msgs = bancoMensagens.filter(function(m) {
        var bateCli = (cliSel === "TODOS" || m.remetente === cliSel || m.destinatario === cliSel);
        var bateColab = (colabSel === "TODOS" || m.remetente === colabSel || m.destinatario === colabSel);
        return bateCli && bateColab;
      });

      if (msgs.length === 0) {
        cont.innerHTML = "<p style='color:var(--text-muted); margin:0;'>Nenhum histórico de mensagem encontrado com os filtros atuais.</p>";
      } else {
        cont.innerHTML = msgs.map(function(m) {
          return '<div style="background:#FFFFFF; padding:10px 14px; border-radius:10px; border:1px solid #E2E8F0; margin-bottom:8px; box-shadow:0 2px 6px rgba(0,0,0,0.02);">' +
              '<div style="display:flex; justify-content:space-between; font-size:0.75rem; color:var(--text-muted); margin-bottom:4px;">' +
                '<span><strong>De:</strong> ' + m.remetente + ' | <strong>Para:</strong> ' + m.destinatario + '</span>' +
                '<span>' + (m.data || '') + '</span>' +
              '</div>' +
              '<div style="font-size:0.88rem; color:var(--text-dark);">' + m.texto + '</div>' +
            '</div>';
        }).join('');
      }
    }

    function calcularValoresFinanceirosEditLote() {
      var pcs = parseInt(document.getElementById('editLotePcs').value) || 0;
      var vBruto = parseFloat(document.getElementById('editLoteValorBruto').value) || 0;
      var descPct = parseFloat(document.getElementById('editLoteDesconto').value) || 0;

      var vDesconto = vBruto * (descPct / 100);
      var vFinal = vBruto - vDesconto;
      var vPorPeca = pcs > 0 ? (vFinal / pcs) : 0;

      document.getElementById('labelValTotalComDesconto').innerText = "R$ " + vFinal.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
      document.getElementById('labelValPorPecaFinal').innerText = "R$ " + vPorPeca.toLocaleString('pt-BR', { minimumFractionDigits: 2, maximumFractionDigits: 2 }) + " / und";
    }

    function abrirModalEditarLoteDir(id) {
      var l = bancoLotes4Etapas.find(function(item) { return item.id === id; });
      if(l) {
        document.getElementById('editLoteIdHidden').value = l.id;
        document.getElementById('editLoteNum').value = l.numLote || "";
        document.getElementById('editLotePcs').value = l.pcs || "";
        document.getElementById('editLoteEtapa').value = l.etapa;
        document.getElementById('editLoteSetorAtual').value = l.setorAtual || "1. Entrada Bruta";
        
        document.getElementById('editLoteValorBruto').value = l.valorTotalBruto || l.valorTotal || "";
        document.getElementById('editLoteDesconto').value = l.descontoPct || l.desconto || "";
        document.getElementById('editLoteObs').value = l.obs || "";

        renderizarEdicaoSetoresDiretoria(l);
        calcularValoresFinanceirosEditLote();
        document.getElementById('modalEditarLoteDir').style.display = 'flex';
      }
    }

    function fecharModalEditarLoteDir() { document.getElementById('modalEditarLoteDir').style.display = 'none'; }

    function salvarEdicaoLoteDir() {
      var id = parseInt(document.getElementById('editLoteIdHidden').value);
      var l = bancoLotes4Etapas.find(function(item) { return item.id === id; });
      if(l) {
        l.numLote = document.getElementById('editLoteNum').value.trim();
        l.pcs = parseInt(document.getElementById('editLotePcs').value) || l.pcs;
        l.etapa = parseInt(document.getElementById('editLoteEtapa').value);
        l.setorAtual = document.getElementById('editLoteSetorAtual').value;
        
        salvarValoresEditadosSetoresDiretoria(l);

        var vBruto = parseFloat(document.getElementById('editLoteValorBruto').value) || 0;
        var descPct = parseFloat(document.getElementById('editLoteDesconto').value) || 0;
        var vFinal = vBruto - (vBruto * (descPct / 100));
        var vPorPeca = l.pcs > 0 ? (vFinal / l.pcs) : 0;

        l.valorTotalBruto = vBruto.toFixed(2);
        l.descontoPct = descPct;
        l.valTotalComDesconto = vFinal.toFixed(2);
        l.valPorPecaFinal = vPorPeca.toFixed(2);
        l.obs = document.getElementById('editLoteObs').value;
        l.editadoColab = false;

        if (l.etapa === 4 || l.setorAtual === "7. Finalização / Liberado") {
          l.etapa = 4;
          l.label = "Finalizado / Liberado";
        }

        salvarDadosNovem();
        alert("✅ Lote, setores e fechamento financeiro gravados com sucesso!");
        fecharModalEditarLoteDir();
        renderizarLotes4Etapas();
      }
    }

    function renderizarLotesColabBancada() {
      var col = usuarioLogadoObjeto;
      var setoresColab = col && Array.isArray(col.setores) ? col.setores : [];
      document.getElementById('subtituloColabBancada').innerText = "Setores Liberados: " + (setoresColab.join(', ') || "Nenhum setor atribuído");
      var cont = document.getElementById('containerColabMeuSetor');
      var htmlMeu = "";
      
      bancoLotes4Etapas.forEach(function(l) {
        if (!l.setorAtual || l.etapa === 4) return;
        var setorLoteLimpo = l.setorAtual.replace(/^[0-9]+\.\s*/, '').trim().toLowerCase();

        var estaNoMeuSetor = setoresColab.some(function(s) { 
          var setorColabLimpo = s.replace(/^[0-9]+\.\s*/, '').trim().toLowerCase();
          return setorLoteLimpo === setorColabLimpo || l.setorAtual === s;
        });

        if (estaNoMeuSetor) {
          htmlMeu += '<div class="card-ampli-item" style="border-color:var(--orange-accent);" onclick="abrirModalOpBancadaLote(' + l.id + ')">' +
              '<span class="badge-status badge-andamento">MEU SETOR — LOTE #' + (l.numLote || 'PENDENTE') + '</span>' +
              '<strong style="display:block; margin-top:6px;">' + l.cliente + '</strong>' +
              '<p>Setor: <strong>' + l.setorAtual + '</strong></p>' +
              '<button class="btn-main btn-orange" style="margin-top:10px; padding:8px;">ABRIR BANCADA ➔</button>' +
            '</div>';
        }
      });
      cont.innerHTML = htmlMeu || "<p style='color:var(--text-muted);'>Nenhum lote pendente no seu setor.</p>";
    }

    function renderizarAgendamentoCliente() { montarCalendarioMesAno(anoCalendarioAtual, mesCalendarioAtual); }

    function mudarMesCalendario(delta) {
      mesCalendarioAtual += delta;
      if(mesCalendarioAtual > 11) { mesCalendarioAtual = 0; anoCalendarioAtual++; }
      if(mesCalendarioAtual < 0) { mesCalendarioAtual = 11; anoCalendarioAtual--; }
      montarCalendarioMesAno(anoCalendarioAtual, mesCalendarioAtual);
    }

    function montarCalendarioMesAno(ano, mes) {
      var grid = document.getElementById('containerCalendarioGrid');
      grid.innerHTML = "";
      var nomesMeses = ["JANEIRO", "FEVEREIRO", "MARÇO", "ABRIL", "MAIO", "JUNHO", "JULHO", "AGOSTO", "SETEMBRO", "OUTUBRO", "NOVEMBRO", "DEZEMBRO"];
      document.getElementById('calMesAnoHeader').innerText = nomesMeses[mes] + " / " + ano;

      ["DOM", "SEG", "TER", "QUA", "QUI", "SEX", "SÁB"].forEach(function(d) { grid.innerHTML += '<div class="cal-day-header">' + d + '</div>'; });
      var primeiroDia = new Date(ano, mes, 1).getDay();
      var totalDias = new Date(ano, mes + 1, 0).getDate();

      for(var i = 0; i < primeiroDia; i++) grid.innerHTML += '<div class="cal-day disabled"></div>';

      for(var d = 1; d <= totalDias; d++) {
        var diaStr = d < 10 ? '0' + d : '' + d;
        var mesStr = (mes + 1) < 10 ? '0' + (mes + 1) : '' + (mes + 1);
        var dataFull = ano + '-' + mesStr + '-' + diaStr;
        var dateObj = new Date(ano, mes, d);
        var diaSemana = dateObj.getDay();

        var jaPassou = dateObj < DATA_HOJE_SISTEMA;
        var eSabDom = (diaSemana === 0 || diaSemana === 6);
        var eFeriado = feriadosLimeiraSP.indexOf(dataFull) !== -1;
        var eOcupado = datasOcupadasAgenda.indexOf(dataFull) !== -1;

        var classeCss = "disponivel"; var statusText = "DISPONÍVEL";
        if(jaPassou) { classeCss = "disabled"; statusText = "PASSOU"; }
        else if(eSabDom) { classeCss = "disabled"; statusText = "FECHADO"; }
        else if(eFeriado) { classeCss = "indisponivel"; statusText = "FERIADO"; }
        else if(eOcupado) { classeCss = "indisponivel"; statusText = "INDISPONÍVEL"; }

        grid.innerHTML += '<div class="cal-day ' + classeCss + '" id="calDay_' + dataFull + '" onclick="selecionarDataAgenda(\'' + dataFull + '\', \'' + statusText + '\')"><strong>' + d + '</strong><span class="cal-status-tag">' + statusText + '</span></div>';
      }
    }

    function selecionarDataAgenda(dataStr, status) {
      if(status !== "DISPONÍVEL") { alert("⚠️ A data " + dataStr + " está " + status + "!"); return; }
      document.querySelectorAll('.cal-day').forEach(function(el) { el.classList.remove('selected'); });
      var el = document.getElementById('calDay_' + dataStr);
      if(el) el.classList.add('selected');
      dataAgendamentoSelecionadaCli = dataStr;
    }

    function calcularPesoPorPcsCli() {
      var pcs = parseInt(document.getElementById('inputAgendQtdPcs').value) || 0;
      var pesoEst = (pcs * fatorMediaPesoGlobal).toFixed(0);
      document.getElementById('inputAgendPesoGramos').value = pesoEst;
      document.getElementById('labelCalcAgendResult').innerText = pcs + " und (~" + pesoEst + "g)";
    }

    function calcularPcsPorPesoCli() {
      var peso = parseFloat(document.getElementById('inputAgendPesoGramos').value) || 0;
      var pcsEst = Math.round(peso / fatorMediaPesoGlobal);
      document.getElementById('inputAgendQtdPcs').value = pcsEst;
      document.getElementById('labelCalcAgendResult').innerText = pcsEst + " und (~" + peso + "g)";
    }

    function confirmarAgendamentoLoteClienteSubmit() {
      var cli = usuarioLogadoObjeto;
      var pcs = parseInt(document.getElementById('inputAgendQtdPcs').value) || 0;
      var pesoG = document.getElementById('inputAgendPesoGramos').value || "0";
      var mod = parseInt(document.getElementById('inputAgendQtdModelos').value) || 1;
      var obs = document.getElementById('inputAgendObs').value;

      if(!dataAgendamentoSelecionadaCli) { alert("⚠️ Selecione uma data verde!"); return; }
      if(pcs <= 0) { alert("⚠️ Informe a quantidade!"); return; }

      datasOcupadasAgenda.push(dataAgendamentoSelecionadaCli);

      bancoLotes4Etapas.push({
        id: Date.now(), cliente: cli.marca, etapa: 1, label: "Aguardando Aprovação",
        pcs: pcs, peso: pesoG + "g", dataCadastro: obterDataHoraAtualFormatada(), dataAgendada: dataAgendamentoSelecionadaCli,
        obs: obs, numLote: "", setorAtual: "Pendente", modelos: mod, editadoColab: false, historicoSetores: []
      });
      salvarDadosNovem();

      alert("✅ LOTE AGENDADO COM SUCESSO!");
      navegarPaginaCliente('lotes');
    }

    function renderizarEncartesCliente() {
      var cli = usuarioLogadoObjeto;
      var cont = document.getElementById('containerEncartesClienteExibicao');
      var lista = bancoModelosEncarte[cli.marca] || [];
      cont.innerHTML = lista.map(function(m) {
        return '<div class="card-ampli-item">' +
            '<span class="badge-status badge-andamento">' + m.catJoia.toUpperCase() + '</span>' +
            '<div style="margin:8px 0; background:#F8FAFC; padding:10px; border-radius:8px;">' +
              m.passos.map(function(p) { return '<div>• ' + p + '</div>'; }).join('') +
            '</div>' +
          '</div>';
      }).join('') || "<p style='color:var(--text-muted);'>Nenhum modelo cadastrado.</p>";
    }

    function renderizarInsumosCliente() {
      var cli = usuarioLogadoObjeto;
      var cont = document.getElementById('containerTabelaInsumosClienteExibicao');
      var lista = bancoInsumosCompletos[cli.marca] || [];
      var html = '<table class="tabela-sos"><thead><tr><th>Categoria Joia</th><th>Tipo</th><th>Subcategoria</th><th>Estoque</th></tr></thead><tbody>';
      lista.forEach(function(ins) { html += '<tr><td>' + (ins.catJoia || 'Geral') + '</td><td>' + ins.tipo + '</td><td>' + ins.sub + '</td><td><strong>' + ins.qtd + ' un</strong></td></tr>'; });
      html += '</tbody></table>';
      cont.innerHTML = html;
    }

    function renderizarMensagensCliente() {
      var cli = usuarioLogadoObjeto;
      var rec = document.getElementById('boxMensagensRecebidasCli');
      var msgsRec = bancoMensagens.filter(function(m) { return m.destinatario === "TODOS" || m.destinatario === cli.marca; });
      rec.innerHTML = msgsRec.map(function(m) { return '<div style="border-bottom:1px solid #E2E8F0; padding-bottom:6px; margin-bottom:6px;"><strong>' + m.remetente + ':</strong> ' + m.texto + '</div>'; }).join('');
    }

    function enviarMensagemClienteSubmit() {
      var txt = document.getElementById('inputTextoEnvioCli').value.trim();
      if(txt) {
        bancoMensagens.push({ id: Date.now(), remetente: usuarioLogadoObjeto.marca, destinatario: "Diretoria General", texto: txt, data: obterDataHoraAtualFormatada() });
        salvarDadosNovem();
        document.getElementById('inputTextoEnvioCli').value = "";
        alert("✅ Mensagem enviada!");
        renderizarMensagensCliente();
      }
    }

    function navegarPaginaColab(pag) {
      document.querySelectorAll('.btn-pag-op').forEach(function(b) { b.classList.remove('active'); });
      document.getElementById('pagOpLotes').style.display = 'none';
      document.getElementById('pagOpRegras').style.display = 'none';
      document.getElementById('pagOpEncartes').style.display = 'none';
      document.getElementById('pagOpInsumos').style.display = 'none';
      document.getElementById('pagOpMensagens').style.display = 'none';

      if(pag === 'lotes') { document.getElementById('btnNavOpLotes').classList.add('active'); document.getElementById('pagOpLotes').style.display = 'block'; renderizarLotesColabBancada(); }
      else if(pag === 'regras') { document.getElementById('btnNavOpRegras').classList.add('active'); document.getElementById('pagOpRegras').style.display = 'block'; preencherSelectsRegrasFiltro('selectFiltroSetorRegrasColab', 'selectFiltroClienteRegrasColab'); renderizarRegrasSetoresColab(); }
      else if(pag === 'encartes') { document.getElementById('btnNavOpEncartes').classList.add('active'); document.getElementById('pagOpEncartes').style.display = 'block'; preencherSelectClientesColab('selectFiltroClienteEncarteColab'); renderizarEncartesColabConsulta(); }
      else if(pag === 'insumos') { document.getElementById('btnNavOpInsumos').classList.add('active'); document.getElementById('pagOpInsumos').style.display = 'block'; preencherSelectClientesColab('selectFiltroClienteInsumoColab'); renderizarInsumosColabConsulta(); }
      else if(pag === 'mensagens') { document.getElementById('btnNavOpMensagens').classList.add('active'); document.getElementById('pagOpMensagens').style.display = 'block'; renderizarMensagensColab(); }
    }

    function preencherSelectsRegrasFiltro(elemSetorId, elemClienteId) {
      var selSetor = document.getElementById(elemSetorId);
      selSetor.innerHTML = '<option value="TODOS">Todos os Setores</option>';
      listaSetoresFabricaGeral.forEach(function(s) { selSetor.innerHTML += '<option value="' + s + '">' + s + '</option>'; });

      var selCli = document.getElementById(elemClienteId);
      selCli.innerHTML = '<option value="TODOS">Todos os Clientes</option>';
      bancoClientes.forEach(function(c) { selCli.innerHTML += '<option value="' + c.marca + '">' + c.marca + '</option>'; });
    }

    function renderizarRegrasSetoresColab() {
      var setorSel = document.getElementById('selectFiltroSetorRegrasColab').value || "TODOS";
      var cliSel = document.getElementById('selectFiltroClienteRegrasColab').value || "TODOS";
      var cont = document.getElementById('containerCardsRegrasColabConsulta');
      var html = "";

      listaSetoresFabricaGeral.forEach(function(setor) {
        if(setorSel === "TODOS" || setorSel === setor) {
          var regrasSetor = bancoRegrasSetores[setor] || [];
          var regrasFiltradas = regrasSetor.filter(function(r) { return cliSel === "TODOS" || r.cliente === cliSel; });
          
          if(regrasFiltradas.length > 0) {
            html += '<div style="margin-bottom:15px;"><strong style="color:var(--header-bg); font-size:1rem;">📍 ' + setor + '</strong>';
            regrasFiltradas.forEach(function(r) {
              html += '<div class="regra-item-box"><span><strong>[' + r.cliente + ']:</strong> ' + r.regra + '</span></div>';
            });
            html += '</div>';
          }
        }
      });

      cont.innerHTML = html || "<p style='color:var(--text-muted);'>Nenhuma regra encontrada com os filtros selecionados.</p>";
    }

    function preencherSelectClientesColab(elemId) {
      var sel = document.getElementById(elemId);
      sel.innerHTML = "";
      bancoClientes.forEach(function(c) { sel.innerHTML += '<option value="' + c.marca + '">' + c.marca + '</option>'; });
    }

    function renderizarEncartesColabConsulta() {
      var cli = document.getElementById('selectFiltroClienteEncarteColab').value || (bancoClientes[0] ? bancoClientes[0].marca : "");
      var cont = document.getElementById('containerCardsEncarteColabConsulta');
      var lista = bancoModelosEncarte[cli] || [];
      cont.innerHTML = lista.map(function(m) { return '<div class="card-ampli-item"><strong>' + m.catJoia + '</strong><br>' + m.passos.join('<br>') + '</div>'; }).join('') || "<p style='color:var(--text-muted);'>Nenhum modelo.</p>";
    }

    function renderizarInsumosColabConsulta() {
      var cli = document.getElementById('selectFiltroClienteInsumoColab').value || (bancoClientes[0] ? bancoClientes[0].marca : "");
      var cont = document.getElementById('containerTabelaInsumosColabConsulta');
      var lista = bancoInsumosCompletos[cli] || [];
      var html = '<table class="tabela-sos"><thead><tr><th>Categoria</th><th>Tipo</th><th>Estoque</th><th>Gôndola</th></tr></thead><tbody>';
      lista.forEach(function(ins) { html += '<tr><td>' + (ins.catJoia || 'Geral') + '</td><td>' + ins.tipo + '</td><td>' + ins.qtd + ' un</td><td>' + (ins.gondula || 'N/I') + '</td></tr>'; });
      html += '</tbody></table>';
      cont.innerHTML = html;
    }

    function renderizarMensagensColab() {
      var col = usuarioLogadoObjeto;
      var rec = document.getElementById('boxMensagensRecebidasColab');
      var msgsRec = bancoMensagens.filter(function(m) { return m.destinatario === "TODOS" || m.destinatario === "EQUIPE" || m.destinatario === col.nome; });
      rec.innerHTML = msgsRec.map(function(m) { return '<div><strong>' + m.remetente + ':</strong> ' + m.texto + '</div>'; }).join('');
    }

    function enviarMensagemColabSubmit() {
      var txt = document.getElementById('inputTextoEnvioColab').value.trim();
      if(txt) {
        bancoMensagens.push({ id: Date.now(), remetente: usuarioLogadoObjeto.nome, destinatario: "Diretoria General", texto: txt, data: obterDataHoraAtualFormatada() });
        salvarDadosNovem();
        document.getElementById('inputTextoEnvioColab').value = "";
        alert("✅ Mensagem enviada!");
        renderizarMensagensColab();
      }
    }

    function navegarPaginaDiretoria(pag) {
      document.querySelectorAll('.btn-pag-dir').forEach(function(b) { b.classList.remove('active'); });
      document.getElementById('pagDirLotes').style.display = 'none';
      document.getElementById('pagDirClientes').style.display = 'none';
      document.getElementById('pagDirColab').style.display = 'none';
      document.getElementById('pagDirInsumos').style.display = 'none';
      document.getElementById('pagDirEncarte').style.display = 'none';
      document.getElementById('pagDirRegras').style.display = 'none';
      document.getElementById('pagDirHistoricoMsg').style.display = 'none';
      document.getElementById('pagDirConfigs').style.display = 'none';

      if(pag === 'lotes') { document.getElementById('btnNavLotes').classList.add('active'); document.getElementById('pagDirLotes').style.display = 'block'; atualizarSelectClientesFiltroLotes(); renderizarLotes4Etapas(); }
      else if(pag === 'clientes') { document.getElementById('btnNavClientes').classList.add('active'); document.getElementById('pagDirClientes').style.display = 'block'; renderizarCardsClientesAmplo(); }
      else if(pag === 'colab') { document.getElementById('btnNavColab').classList.add('active'); document.getElementById('pagDirColab').style.display = 'block'; renderizarCardsColabAmplo(); }
      else if(pag === 'insumos') { document.getElementById('btnNavInsumos').classList.add('active'); document.getElementById('pagDirInsumos').style.display = 'block'; renderizarSelecaoClientesInsumos(); }
      else if(pag === 'encarte') { document.getElementById('btnNavEncarte').classList.add('active'); document.getElementById('pagDirEncarte').style.display = 'block'; renderizarSelecaoClientesEncarte(); }
      else if(pag === 'regras') { document.getElementById('btnNavRegras').classList.add('active'); document.getElementById('pagDirRegras').style.display = 'block'; preencherSelectsRegrasFiltro('selectFiltroSetorRegrasDir', 'selectFiltroClienteRegrasDir'); renderizarCardsSetoresRegrasDir(); }
      else if(pag === 'historicoMsg') { document.getElementById('btnNavHistoricoMsg').classList.add('active'); document.getElementById('pagDirHistoricoMsg').style.display = 'block'; preencherSelectsFiltroMensagensDiretoria(); renderizarHistoricoMensagensDiretoria(); }
      else if(pag === 'configs') { document.getElementById('btnNavConfigs').classList.add('active'); document.getElementById('pagDirConfigs').style.display = 'block'; renderizarCategoriasJoiasCentral(); }
    }

    function renderizarPainelDiretoria() { navegarPaginaDiretoria('lotes'); }

    function atualizarSelectClientesFiltroLotes() {
      var sel = document.getElementById('filtroCliLotes4Etapas');
      sel.innerHTML = '<option value="TODOS">TODAS AS MARCAS (VISÃO GERAL)</option>';
      bancoClientes.forEach(function(c) { sel.innerHTML += '<option value="' + c.marca + '">' + c.marca + '</option>'; });
    }

    function renderizarLotes4Etapas() {
      var filtro = document.getElementById('filtroCliLotes4Etapas').value;
      var cont = document.getElementById('containerLotes4EtapasAmplo');
      var lotes = (filtro === "TODOS") ? bancoLotes4Etapas : bancoLotes4Etapas.filter(function(l) { return l.cliente === filtro; });

      var html = '<div class="cards-grid-amplos">';
      
      html += '<div class="coluna-etapa-lotes" style="background:#FFF7ED;"><h4 style="color:#C2410C;">1. Aguardando Aprovação (' + lotes.filter(function(l){return l.etapa===1;}).length + ')</h4>';
      lotes.filter(function(l){return l.etapa===1;}).forEach(function(l) { 
        html += '<div class="card-ampli-item" onclick="abrirModalEditarLoteDir(' + l.id + ')"><strong>' + l.cliente + '</strong><p>Volume: ' + l.pcs + ' und</p></div>'; 
      });
      html += '</div>';

      html += '<div class="coluna-etapa-lotes" style="background:#E0F2FE;"><h4 style="color:#0369A1;">2. Aguardando Chegada (' + lotes.filter(function(l){return l.etapa===2;}).length + ')</h4>';
      lotes.filter(function(l){return l.etapa===2;}).forEach(function(l) { 
        html += '<div class="card-ampli-item" onclick="abrirModalEditarLoteDir(' + l.id + ')"><strong>' + l.cliente + '</strong><p>Volume: ' + l.pcs + ' und</p></div>'; 
      });
      html += '</div>';

      html += '<div class="coluna-etapa-lotes" style="background:#FEF3C7;"><h4 style="color:#B45309;">3. Cadastrados (' + lotes.filter(function(l){return l.etapa===3 && l.setorAtual !== "7. Finalização / Liberado";}).length + ')</h4>';
      lotes.filter(function(l){return l.etapa===3 && l.setorAtual !== "7. Finalização / Liberado";}).forEach(function(l) { 
        html += '<div class="card-ampli-item" onclick="abrirModalEditarLoteDir(' + l.id + ')"><strong>' + l.cliente + '</strong><p>Setor: <strong>' + l.setorAtual + '</strong></p></div>'; 
      });
      html += '</div>';

      html += '<div class="coluna-etapa-lotes" style="background:#D1FAE5;"><h4 style="color:#065F46;">4. Finalizados (' + lotes.filter(function(l){return l.etapa===4 || l.setorAtual === "7. Finalização / Liberado";}).length + ')</h4>';
      lotes.filter(function(l){return l.etapa===4 || l.setorAtual === "7. Finalização / Liberado";}).forEach(function(l) { 
        html += '<div class="card-ampli-item" onclick="abrirModalEditarLoteDir(' + l.id + ')"><strong>' + l.cliente + '</strong><p>Volume: ' + l.pcs + ' und</p></div>'; 
      });
      html += '</div></div>';
      cont.innerHTML = html;
    }

    function renderizarCardsSetoresRegrasDir() {
      var setorSel = document.getElementById('selectFiltroSetorRegrasDir').value || "TODOS";
      var cliSel = document.getElementById('selectFiltroClienteRegrasDir').value || "TODOS";
      var cont = document.getElementById('containerCardsSetoresRegrasDir');
      var html = "";

      listaSetoresFabricaGeral.forEach(function(setor) {
        if(setorSel === "TODOS" || setorSel === setor) {
          var regrasSetor = bancoRegrasSetores[setor] || [];
          var regrasFiltradas = regrasSetor.filter(function(r) { return cliSel === "TODOS" || r.cliente === cliSel; });

          html += '<div class="card-ampli-item">' +
              '<div style="display:flex; justify-content:space-between; align-items:center;">' +
                '<strong>' + setor + '</strong>' +
                '<button class="btn-main btn-green" style="width:auto; padding:4px 10px; font-size:0.7rem;" onclick="abrirModalAddRegraSetor(\'' + setor + '\')">+ ADD</button>' +
              '</div>' +
              '<div style="margin-top:10px;">' +
                (regrasFiltradas.length > 0 ? regrasFiltradas.map(function(r) { 
                  var realIdx = regrasSetor.indexOf(r);
                  return '<div class="regra-item-box"><span><strong>[' + r.cliente + ']:</strong> ' + r.regra + '</span><b style="color:red; cursor:pointer;" onclick="excluirRegraSetorDirect(\'' + setor + '\',' + realIdx + ')">✕</b></div>'; 
                }).join('') : '<p style="font-size:0.78rem; color:var(--text-muted);">Nenhuma regra cadastrada.</p>') +
              '</div>' +
            '</div>';
        }
      });
      cont.innerHTML = html;
    }

    function abrirModalAddRegraSetor(setor) {
      document.getElementById('hiddenRegraSetorNome').value = setor;
      document.getElementById('tituloModalRegraSetor').innerText = "Adicionar Regra — " + setor;
      var sel = document.getElementById('mRegraSelectCliente');
      sel.innerHTML = "";
      bancoClientes.forEach(function(c) { sel.innerHTML += '<option value="' + c.marca + '">' + c.marca + '</option>'; });
      document.getElementById('mRegraTexto').value = "";
      document.getElementById('modalAddRegraSetor').style.display = 'flex';
    }

    function fecharModalAddRegraSetor() { document.getElementById('modalAddRegraSetor').style.display = 'none'; }

    function salvarNovaRegraSetorSubmit() {
      var setor = document.getElementById('hiddenRegraSetorNome').value;
      var cli = document.getElementById('mRegraSelectCliente').value;
      var txt = document.getElementById('mRegraTexto').value.trim();
      if(!txt) return;

      if(!bancoRegrasSetores[setor]) bancoRegrasSetores[setor] = [];
      bancoRegrasSetores[setor].push({ id: Date.now(), cliente: cli, regra: txt });
      salvarDadosNovem();

      alert("✅ Regra adicionada!");
      fecharModalAddRegraSetor();
      renderizarCardsSetoresRegrasDir();
    }

    function excluirRegraSetorDirect(setor, idx) {
      if(confirm("⚠️ AVISO 1/2: Tem certeza que deseja excluir esta regra?") && confirm("⚠️ AVISO 2/2: CONFIRMAÇÃO FINAL: Excluir regra definitivamente?")) {
        bancoRegrasSetores[setor].splice(idx, 1);
        salvarDadosNovem();
        renderizarCardsSetoresRegrasDir();
      }
    }

    function renderizarCardsClientesAmplo() {
      var cont = document.getElementById('containerCardsClientesAmplo');
      cont.innerHTML = bancoClientes.map(function(c) {
        return '<div class="card-ampli-item">' +
            '<span class="badge-status badge-concluido">' + c.categoria + '</span>' +
            '<strong style="display:block; font-size:1.15rem; margin-top:8px;">' + c.marca + '</strong>' +
            '<p style="font-size:0.82rem;">Login: ' + c.login + ' | Senha: ' + c.senha + '</p>' +
            '<div style="display:flex; gap:6px; margin-top:10px; flex-wrap:wrap;">' +
              '<button class="btn-main btn-orange" style="padding:6px 10px; font-size:0.72rem; width:auto;" onclick="abrirModalEditarCliente(' + c.id + ')">EDITAR</button>' +
              '<button class="btn-main" style="background:#64748B; padding:6px 10px; font-size:0.72rem; width:auto;" onclick="inativarClienteSubmit(' + c.id + ')">INATIVAR</button>' +
              '<button class="btn-main btn-danger" style="padding:6px 10px; font-size:0.72rem; width:auto;" onclick="excluirClienteDefinitivoSubmit(' + c.id + ', false)">EXCLUIR ✕</button>' +
            '</div>' +
          '</div>';
      }).join('') || "<p style='color:var(--text-muted);'>Nenhum cliente ativo.</p>";

      var contInat = document.getElementById('containerCardsClientesInativos');
      contInat.innerHTML = bancoClientesInativos.map(function(c) {
        return '<div class="card-ampli-item" style="opacity:0.8; background:#F1F5F9;">' +
            '<span class="badge-status badge-espera">INATIVO</span>' +
            '<strong style="display:block; font-size:1.15rem; margin-top:8px;">' + c.marca + '</strong>' +
            '<p style="font-size:0.82rem;">Login: ' + c.login + '</p>' +
            '<div style="display:flex; gap:6px; margin-top:10px; flex-wrap:wrap;">' +
              '<button class="btn-main btn-green" style="padding:6px 10px; font-size:0.72rem; width:auto;" onclick="reativarClienteSubmit(' + c.id + ')">REATIVAR</button>' +
              '<button class="btn-main btn-danger" style="padding:6px 10px; font-size:0.72rem; width:auto;" onclick="excluirClienteDefinitivoSubmit(' + c.id + ', true)">EXCLUIR DEFINITIVO ✕</button>' +
            '</div>' +
          '</div>';
      }).join('') || "<p style='color:var(--text-muted);'>Nenhum cliente inativo.</p>";
    }

    function abrirModalCadastrarCliente() {
      document.getElementById('mEditCliIdHidden').value = "";
      document.getElementById('modalClienteTitulo').innerText = "Cadastrar Cliente";
      document.getElementById('mCadCliNome').value = "";
      document.getElementById('mCadCliLogin').value = "";
      document.getElementById('mCadCliSenha').value = "123";
      document.getElementById('modalCadCliente').style.display = 'flex';
    }

    function abrirModalEditarCliente(id) {
      var c = bancoClientes.find(function(item) { return item.id == id; });
      if(c) {
        document.getElementById('mEditCliIdHidden').value = c.id;
        document.getElementById('modalClienteTitulo').innerText = "Editar Cliente — " + c.marca;
        document.getElementById('mCadCliNome').value = c.marca;
        document.getElementById('mCadCliLogin').value = c.login;
        document.getElementById('mCadCliSenha').value = c.senha;
        document.getElementById('mCadCliCat').value = c.categoria.indexOf("Diamante") !== -1 ? "Diamante" : "Ouro";
        document.getElementById('mCadCliInicio').value = c.inicio;
        document.getElementById('modalCadCliente').style.display = 'flex';
      }
    }

    function fecharModalCadCliente() { document.getElementById('modalCadCliente').style.display = 'none'; }

    function salvarClienteModalSubmit() {
      var id = document.getElementById('mEditCliIdHidden').value;
      var nome = document.getElementById('mCadCliNome').value.trim();
      var login = document.getElementById('mCadCliLogin').value.trim();
      var senha = document.getElementById('mCadCliSenha').value.trim();
      var cat = document.getElementById('mCadCliCat').value;
      var ini = document.getElementById('mCadCliInicio').value.trim();

      var cota = 1500;
      if(cat.indexOf("Iniciante") !== -1) cota = 500;
      if(cat.indexOf("Ouro") !== -1) cota = 1000;
      if(cat.indexOf("Black") !== -1) cota = 2000;

      if(!nome || !login) return;

      if(id) {
        var c = bancoClientes.find(function(item) { return item.id == id; });
        if(c) { c.marca = nome; c.login = login; c.senha = senha; c.categoria = cat; c.cotaMax = cota; c.inicio = ini; }
      } else {
        bancoClientes.push({ id: Date.now(), marca: nome, login: login, senha: senha, categoria: cat, cotaMax: cota, enviadoMes: 0, inicio: ini });
      }

      salvarDadosNovem();
      alert("✅ Cliente salvo com sucesso na nuvem!");
      fecharModalCadCliente();
      renderizarCardsClientesAmplo();
      selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
    }

    function inativarClienteSubmit(id) {
      var c = bancoClientes.find(function(item) { return item.id == id; });
      if(c && confirm("⚠️ AVISO 1/2: Deseja mover a marca '" + c.marca + "' para CLIENTES INATIVOS?") && confirm("⚠️ AVISO 2/2: CONFIRMAÇÃO FINAL: Mover para inativos?")) {
        var idx = bancoClientes.findIndex(function(item) { return item.id == id; });
        if(idx > -1) {
          var clienteRemovido = bancoClientes.splice(idx, 1)[0];
          bancoClientesInativos.push(clienteRemovido);
        }
        salvarDadosNovem();
        renderizarCardsClientesAmplo();
        selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
      }
    }

    function excluirClienteDefinitivoSubmit(id, eInativo) {
      var listaOrigem = eInativo ? bancoClientesInativos : bancoClientes;
      var c = listaOrigem.find(function(item) { return item.id == id; });
      if(!c) return;

      if(confirm("⚠️ AVISO 1/2 (PERIGO): Deseja EXCLUIR DEFINITIVAMENTE a marca '" + c.marca + "'?") && confirm("⚠️ AVISO 2/2 (CONFIRMAÇÃO FINAL): Esta ação irá apagar TODOS os insumos, encartes e regras vinculados a este cliente e NÃO PODERÁ SER DESFEITA! Confirmar exclusão?")) {
        var idx = listaOrigem.findIndex(function(item) { return item.id == id; });
        if(idx > -1) {
          listaOrigem.splice(idx, 1);
        }

        expurgarDadosClientesExcluidos();
        salvarDadosNovem();

        alert("🗑️ Cliente '" + c.marca + "' e todos os seus dados vinculados foram excluídos com sucesso!");
        renderizarCardsClientesAmplo();
        selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
      }
    }

    function reativarClienteSubmit(id) {
      var idx = bancoClientesInativos.findIndex(function(item) { return item.id == id; });
      if(idx > -1) {
        var clienteReativado = bancoClientesInativos.splice(idx, 1)[0];
        bancoClientes.push(clienteReativado);
        salvarDadosNovem();
        renderizarCardsClientesAmplo();
        selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
      }
    }

    function renderizarCardsColabAmplo() {
      var cont = document.getElementById('containerCardsColabAmplo');
      cont.innerHTML = bancoColaboradores.map(function(c) {
        var setoresList = Array.isArray(c.setores) ? c.setores.join(', ') : '';
        return '<div class="card-ampli-item">' +
            '<strong style="font-size:1.15rem;">' + c.nome + '</strong>' +
            '<p style="font-size:0.82rem; margin:4px 0;">Login: <strong>' + c.login + '</strong> | Senha: <strong>' + c.senha + '</strong></p>' +
            '<p style="font-size:0.82rem; margin:4px 0;">WhatsApp: ' + c.fone + '</p>' +
            '<p style="font-size:0.78rem; color:var(--orange-accent); margin-top:6px;"><strong>Setores:</strong> ' + (setoresList || "Nenhum") + '</p>' +
            '<div style="display:flex; gap:8px; margin-top:10px;">' +
              '<button class="btn-main btn-orange" style="padding:6px 12px; font-size:0.72rem; width:auto;" onclick="abrirModalEditarColaborador(' + c.id + ')">EDITAR</button>' +
              '<button class="btn-main btn-danger" style="font-size:0.72rem; width:auto; padding:6px 12px;" onclick="excluirColaboradorSubmit(' + c.id + ')">EXCLUIR DEFINITIVO ✕</button>' +
            '</div>' +
          '</div>';
      }).join('') || "<p style='color:var(--text-muted);'>Nenhum colaborador cadastrado.</p>";
    }

    function abrirModalCadastrarColaborador() {
      document.getElementById('mEditColabIdHidden').value = "";
      document.getElementById('modalColabTitulo').innerText = "Cadastrar Colaborador";
      document.getElementById('mCadColabNome').value = "";
      document.getElementById('mCadColabFone').value = "";
      document.getElementById('mCadColabLogin').value = "";
      document.getElementById('mCadColabSenha').value = "123";
      document.querySelectorAll('#boxSetoresTagsColab .tag-setor-btn').forEach(function(el) { el.classList.remove('selected'); });
      document.getElementById('modalCadColaborador').style.display = 'flex';
    }

    function abrirModalEditarColaborador(id) {
      var c = bancoColaboradores.find(function(item) { return item.id == id; });
      if(c) {
        document.getElementById('mEditColabIdHidden').value = c.id;
        document.getElementById('modalColabTitulo').innerText = "Editar Colaborador — " + c.nome;
        document.getElementById('mCadColabNome').value = c.nome;
        document.getElementById('mCadColabFone').value = c.fone;
        document.getElementById('mCadColabLogin').value = c.login;
        document.getElementById('mCadColabSenha').value = c.senha;

        var setoresDoColab = Array.isArray(c.setores) ? c.setores : [];
        document.querySelectorAll('#boxSetoresTagsColab .tag-setor-btn').forEach(function(el) {
          var setorData = el.getAttribute('data-setor') || el.innerText;
          var marcado = setoresDoColab.some(function(s) { return s === setorData || setorData.indexOf(s) !== -1 || s.indexOf(setorData) !== -1; });
          if (marcado) el.classList.add('selected');
          else el.classList.remove('selected');
        });

        document.getElementById('modalCadColaborador').style.display = 'flex';
      }
    }

    function fecharModalCadColaborador() { document.getElementById('modalCadColaborador').style.display = 'none'; }
    function toggleSetorTag(el) { el.classList.toggle('selected'); }

    function salvarColaboradorModalSubmit() {
      var id = document.getElementById('mEditColabIdHidden').value;
      var nome = document.getElementById('mCadColabNome').value.trim();
      var fone = document.getElementById('mCadColabFone').value.trim();
      var login = document.getElementById('mCadColabLogin').value.trim();
      var senha = document.getElementById('mCadColabSenha').value.trim();
      var tags = Array.from(document.querySelectorAll('#boxSetoresTagsColab .tag-setor-btn.selected')).map(function(el) { return el.getAttribute('data-setor') || el.innerText; });

      if(!nome || !login) { alert("⚠️ Informe o nome e o login do colaborador!"); return; }

      if(id) {
        var c = bancoColaboradores.find(function(item) { return item.id == id; });
        if(c) { c.nome = nome; c.fone = fone; c.login = login; c.senha = senha; c.setores = tags; }
      } else {
        bancoColaboradores.push({ id: Date.now(), nome: nome, fone: fone, login: login, senha: senha, setores: tags });
      }

      salvarDadosNovem();
      alert("✅ Colaborador salvo com sucesso na nuvem!");
      fecharModalCadColaborador();
      renderizarCardsColabAmplo();
      selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
    }

    function excluirColaboradorSubmit(id) {
      var c = bancoColaboradores.find(function(item) { return item.id == id; });
      if(c && confirm("⚠️ AVISO 1/2: Tem certeza que deseja excluir o colaborador '" + c.nome + "'?") && confirm("⚠️ AVISO 2/2: CONFIRMAÇÃO FINAL: Excluir colaborador definitivamente do sistema?")) {
        var idx = bancoColaboradores.findIndex(function(item) { return item.id == id; });
        if(idx > -1) bancoColaboradores.splice(idx, 1);
        salvarDadosNovem();
        renderizarCardsColabAmplo();
        selecionarPerfilAcesso(perfilAcessoSelecionadoTab);
      }
    }

    function renderizarSelecaoClientesInsumos() {
      expurgarDadosClientesExcluidos();
      document.getElementById('secaoSelecaoClienteInsumo').style.display = 'block';
      document.getElementById('secaoDetalheInsumosClienteSel').style.display = 'none';
      
      var contAtivos = document.getElementById('containerCardsClientesInsumosSelection');
      var contInativos = document.getElementById('containerCardsClientesInsumosInativosSelection');
      var marcasInativas = bancoClientesInativos.map(function(c) { return c.marca; });

      var htmlAtivos = "";
      var htmlInativos = "";

      Object.keys(bancoInsumosCompletos).forEach(function(cli) {
        var eInativo = marcasInativas.indexOf(cli) !== -1;
        var card = '<div class="card-ampli-item" ' + (eInativo ? 'style="opacity:0.7; background:#F1F5F9;"' : '') + ' onclick="abrirDetalheInsumosClienteDirect(\'' + cli + '\')">' +
            '<strong style="font-size:1.15rem;">' + cli + (eInativo ? ' (INATIVO)' : '') + '</strong>' +
            '<p style="font-size:0.85rem; color:var(--text-muted); margin-top:8px;">Itens: <strong>' + bancoInsumosCompletos[cli].length + '</strong></p>' +
          '</div>';

        if (eInativo) htmlInativos += card;
        else htmlAtivos += card;
      });

      contAtivos.innerHTML = htmlAtivos || "<p style='color:var(--text-muted);'>Nenhum insumo de cliente ativo.</p>";
      contInativos.innerHTML = htmlInativos || "<p style='color:var(--text-muted);'>Nenhum insumo de cliente inativo.</p>";
    }

    function abrirDetalheInsumosClienteDirect(cli) {
      clienteInsumosSelecionadoAtual = cli;
      document.getElementById('secaoSelecaoClienteInsumo').style.display = 'none';
      document.getElementById('secaoDetalheInsumosClienteSel').style.display = 'block';
      document.getElementById('tituloInsumosClienteSel').innerText = cli + " — Estoque de Insumos";

      var lista = bancoInsumosCompletos[cli] || [];
      var html = '<table class="tabela-sos"><thead><tr><th>Categoria Joia</th><th>Tipo</th><th>Subcategoria</th><th>Estoque</th><th>Gôndola</th><th>Ações</th></tr></thead><tbody>';
      lista.forEach(function(ins, idx) {
        html += '<tr>' +
            '<td><strong>' + (ins.catJoia || 'Geral / Todas') + '</strong></td>' +
            '<td><strong>' + ins.tipo + '</strong></td>' +
            '<td>' + ins.sub + '</td>' +
            '<td><strong>' + ins.qtd + ' un</strong></td>' +
            '<td><input type="text" value="' + (ins.gondula || '') + '" style="width:70px; padding:4px;" onchange="alterarGondulaInsumoDirect(\'' + cli + '\', ' + idx + ', this.value)"></td>' +
            '<td>' +
              '<button class="btn-main btn-green" style="padding:4px 8px; font-size:0.7rem; width:auto; margin-right:2px;" onclick="lancarEntradaSaidaInsumo(\'' + cli + '\', ' + idx + ', \'entrada\')">+ Entrada</button>' +
              '<button class="btn-main btn-orange" style="padding:4px 8px; font-size:0.7rem; width:auto; margin-right:4px;" onclick="lancarEntradaSaidaInsumo(\'' + cli + '\', ' + idx + ', \'saida\')">- Baixa</button>' +
              '<button class="btn-main" style="padding:4px 8px; font-size:0.7rem; width:auto; background:#3B82F6; margin-right:2px;" onclick="abrirModalEditarInsumoDirect(\'' + cli + '\', ' + idx + ')">EDITAR</button>' +
              '<button class="btn-main btn-danger" style="padding:4px 8px; font-size:0.7rem; width:auto;" onclick="excluirInsumoDirect(\'' + cli + '\', ' + idx + ')">EXCLUIR</button>' +
            '</td>' +
          '</tr>';
      });
      html += '</tbody></table>';
      document.getElementById('containerInsumosTabelaDirect').innerHTML = html;
    }

    function voltarSelecaoClienteInsumo() { 
      clienteInsumosSelecionadoAtual = "";
      renderizarSelecaoClientesInsumos(); 
    }

    function abrirModalCadastrarInsumoParaClienteAtual() { abrirModalCadastrarInsumo(clienteInsumosSelecionadoAtual); }

    function abrirModalCadastrarInsumo(clientePreSelecionado) {
      document.getElementById('mEditInsumoCliOriginalHidden').value = "";
      document.getElementById('mEditInsumoIdxHidden').value = "";
      document.getElementById('modalInsumoTitulo').innerText = "Cadastrar Novo Insumo";
      document.getElementById('btnSalvarModalInsumo').innerText = "SALVAR INSUMO";

      var selCli = document.getElementById('mCadInsCli');
      selCli.innerHTML = "";
      bancoClientes.forEach(function(c) { selCli.innerHTML += '<option value="' + c.marca + '">' + c.marca + '</option>'; });

      if (clientePreSelecionado && clientePreSelecionado !== "") selCli.value = clientePreSelecionado;
      else if (clienteInsumosSelecionadoAtual !== "") selCli.value = clienteInsumosSelecionadoAtual;

      renderizarTagsCategoriasJoiaInsumo([]);
      preencherSelectTiposInsumo();
      document.getElementById('inputNovoTipoInsumoTemp').value = "";
      document.getElementById('mCadInsSub').value = "";
      document.getElementById('mCadInsQtd').value = "";
      document.getElementById('mCadInsGondula').value = "";
      document.getElementById('modalCadInsumo').style.display = 'flex';
    }

    function abrirModalEditarInsumoDirect(cli, idx) {
      var ins = bancoInsumosCompletos[cli][idx];
      if (!ins) return;

      document.getElementById('mEditInsumoCliOriginalHidden').value = cli;
      document.getElementById('mEditInsumoIdxHidden').value = idx;
      document.getElementById('modalInsumoTitulo').innerText = "Editar Insumo — " + cli;
      document.getElementById('btnSalvarModalInsumo').innerText = "ATUALIZAR INSUMO";

      var selCli = document.getElementById('mCadInsCli');
      selCli.innerHTML = "";
      bancoClientes.forEach(function(c) { selCli.innerHTML += '<option value="' + c.marca + '">' + c.marca + '</option>'; });
      selCli.value = cli;

      var arrayCategoriasAtribuídas = ins.catJoia ? ins.catJoia.split(',').map(function(s){ return s.trim(); }) : [];
      renderizarTagsCategoriasJoiaInsumo(arrayCategoriasAtribuídas);

      preencherSelectTiposInsumo();
      if (ins.tipo && bancoTiposInsumos.indexOf(ins.tipo) === -1) {
        bancoTiposInsumos.push(ins.tipo);
        preencherSelectTiposInsumo();
      }
      document.getElementById('mCadInsTipo').value = ins.tipo;
      document.getElementById('mCadInsSub').value = ins.sub || "";
      document.getElementById('mCadInsQtd').value = ins.qtd || 0;
      document.getElementById('mCadInsGondula').value = ins.gondula || "";
      document.getElementById('modalCadInsumo').style.display = 'flex';
    }

    function renderizarTagsCategoriasJoiaInsumo(categoriasSelecionadas) {
      if (!Array.isArray(categoriasSelecionadas)) categoriasSelecionadas = [];
      var box = document.getElementById('boxCatJoiasInsumoTags');
      var eGeral = categoriasSelecionadas.indexOf("Geral / Todas") !== -1 || categoriasSelecionadas.length === 0;

      var html = '<span class="tag-setor-btn ' + (eGeral ? 'selected' : '') + '" onclick="toggleSetorTag(this)">Geral / Todas</span>';
      bancoCategoriasJoias.forEach(function(cj) { 
        var marcada = categoriasSelecionadas.indexOf(cj) !== -1;
        html += '<span class="tag-setor-btn ' + (marcada ? 'selected' : '') + '" onclick="toggleSetorTag(this)">' + cj + '</span>'; 
      });
      box.innerHTML = html;
    }

    function preencherSelectTiposInsumo() {
      var selTipo = document.getElementById('mCadInsTipo');
      selTipo.innerHTML = "";
      bancoTiposInsumos.forEach(function(t) { selTipo.innerHTML += '<option value="' + t + '">' + t + '</option>'; });
    }

    function adicionarNovoTipoInsumoDirect() {
      var inp = document.getElementById('inputNovoTipoInsumoTemp');
      var val = inp.value.trim();
      if(val) {
        if(bancoTiposInsumos.indexOf(val) === -1) {
          bancoTiposInsumos.push(val);
          salvarDadosNovem();
        }
        preencherSelectTiposInsumo();
        document.getElementById('mCadInsTipo').value = val;
        inp.value = "";
      }
    }

    function fecharModalCadInsumo() { document.getElementById('modalCadInsumo').style.display = 'none'; }

    function salvarNovoInsumoSubmit(e) {
      e.preventDefault();
      var cliOrig = document.getElementById('mEditInsumoCliOriginalHidden').value;
      var idxOrig = document.getElementById('mEditInsumoIdxHidden').value;

      var cliNovo = document.getElementById('mCadInsCli').value;
      var catsSel = Array.from(document.querySelectorAll('#boxCatJoiasInsumoTags .tag-setor-btn.selected')).map(function(el) { return el.innerText; });
      var catJ = catsSel.length > 0 ? catsSel.join(', ') : "Geral / Todas";
      var tipo = document.getElementById('mCadInsTipo').value;
      var sub = document.getElementById('mCadInsSub').value.trim();
      var qtd = parseInt(document.getElementById('mCadInsQtd').value) || 0;
      var gon = document.getElementById('mCadInsGondula').value.trim();

      if (idxOrig !== "") {
        var idxInt = parseInt(idxOrig);
        if (cliOrig === cliNovo) {
          bancoInsumosCompletos[cliNovo][idxInt] = { id: bancoInsumosCompletos[cliNovo][idxInt].id || Date.now(), catJoia: catJ, tipo: tipo, sub: sub, qtd: qtd, gondula: gon };
        } else {
          bancoInsumosCompletos[cliOrig].splice(idxInt, 1);
          if (!bancoInsumosCompletos[cliNovo]) bancoInsumosCompletos[cliNovo] = [];
          bancoInsumosCompletos[cliNovo].push({ id: Date.now(), catJoia: catJ, tipo: tipo, sub: sub, qtd: qtd, gondula: gon });
        }
      } else {
        if(!bancoInsumosCompletos[cliNovo]) bancoInsumosCompletos[cliNovo] = [];
        bancoInsumosCompletos[cliNovo].push({ id: Date.now(), catJoia: catJ, tipo: tipo, sub: sub, qtd: qtd, gondula: gon });
      }

      salvarDadosNovem();
      alert("✅ Insumo salvo com sucesso!");
      fecharModalCadInsumo();

      if (clienteInsumosSelecionadoAtual !== "") abrirDetalheInsumosClienteDirect(clienteInsumosSelecionadoAtual);
      else renderizarSelecaoClientesInsumos();
    }

    function excluirInsumoDirect(cli, idx) {
      if (confirm("⚠️ AVISO 1/2: Tem certeza que deseja excluir este insumo?") && confirm("⚠️ AVISO 2/2: CONFIRMAÇÃO FINAL: Excluir insumo do sistema?")) {
        bancoInsumosCompletos[cli].splice(idx, 1);
        salvarDadosNovem();
        abrirDetalheInsumosClienteDirect(cli);
      }
    }

    function lancarEntradaSaidaInsumo(cli, idx, tipo) {
      var v = parseInt(prompt("Quantidade para " + tipo.toUpperCase() + ":", "100")) || 0;
      if(v > 0) {
        if(tipo === 'entrada') bancoInsumosCompletos[cli][idx].qtd += v;
        else bancoInsumosCompletos[cli][idx].qtd -= v;
        salvarDadosNovem();
        abrirDetalheInsumosClienteDirect(cli);
      }
    }

    function alterarGondulaInsumoDirect(cli, idx, val) {
      bancoInsumosCompletos[cli][idx].gondula = val;
      salvarDadosNovem();
      alert("✅ Gôndola atualizada!");
    }

    function renderizarSelecaoClientesEncarte() {
      expurgarDadosClientesExcluidos();
      document.getElementById('secaoSelecaoClienteEncarte').style.display = 'block';
      document.getElementById('secaoDetalheEncarteClienteSel').style.display = 'none';
      
      var contAtivos = document.getElementById('containerCardsClientesEncarteSelection');
      var contInativos = document.getElementById('containerCardsClientesIncarteInativosSelection');
      var marcasInativas = bancoClientesInativos.map(function(c) { return c.marca; });

      var htmlAtivos = "";
      var htmlInativos = "";

      Object.keys(bancoModelosEncarte).forEach(function(cli) {
        var eInativo = marcasInativas.indexOf(cli) !== -1;
        var card = '<div class="card-ampli-item" ' + (eInativo ? 'style="opacity:0.7; background:#F1F5F9;"' : '') + ' onclick="abrirDetalheEncarteClienteDirect(\'' + cli + '\')">' +
            '<strong style="font-size:1.15rem;">' + cli + (eInativo ? ' (INATIVO)' : '') + '</strong>' +
            '<p style="font-size:0.85rem; color:var(--text-muted); margin-top:8px;">Modelos: <strong>' + bancoModelosEncarte[cli].length + '</strong></p>' +
          '</div>';

        if (eInativo) htmlInativos += card;
        else htmlAtivos += card;
      });

      contAtivos.innerHTML = htmlAtivos || "<p style='color:var(--text-muted);'>Nenhum encarte de cliente ativo.</p>";
      contInativos.innerHTML = htmlInativos || "<p style='color:var(--text-muted);'>Nenhum encarte de cliente inativo.</p>";
    }

    function abrirDetalheEncarteClienteDirect(cli) {
      document.getElementById('secaoSelecaoClienteEncarte').style.display = 'none';
      document.getElementById('secaoDetalheEncarteClienteSel').style.display = 'block';
      document.getElementById('tituloEncarteClienteSel').innerText = cli + " — Modelos de Encarte";
      var cont = document.getElementById('containerCardsCategoriasEncarteClienteSel');
      var lista = bancoModelosEncarte[cli] || [];
      cont.innerHTML = lista.map(function(m, idx) {
        return '<div class="card-ampli-item">' +
            '<div style="display:flex; justify-content:space-between; align-items:center;">' +
              '<span class="badge-status badge-andamento">' + m.catJoia.toUpperCase() + '</span>' +
              '<button class="btn-main btn-danger" style="width:auto; padding:4px 10px; font-size:0.7rem;" onclick="excluirModeloEncarteDirect(\'' + cli + '\', ' + idx + ')">EXCLUIR MODELO</button>' +
            '</div>' +
            '<div style="margin:8px 0; background:#F8FAFC; padding:10px; border-radius:8px;">' +
              m.passos.map(function(p) { return '<div>• ' + p + '</div>'; }).join('') +
            '</div>' +
          '</div>';
      }).join('') || "<p style='color:var(--text-muted);'>Nenhum modelo cadastrado.</p>";
    }

    function excluirModeloEncarteDirect(cli, idx) {
      if(confirm("⚠️ AVISO 1/2: Tem certeza que deseja excluir este modelo de encarte?") && confirm("⚠️ AVISO 2/2: CONFIRMAÇÃO FINAL: Excluir modelo? (A marca continuará no sistema)")) {
        bancoModelosEncarte[cli].splice(idx, 1);
        salvarDadosNovem();
        abrirDetalheEncarteClienteDirect(cli);
      }
    }

    function voltarSelecaoClienteEncarte() {
      document.getElementById('secaoDetalheEncarteClienteSel').style.display = 'none';
      document.getElementById('secaoSelecaoClienteEncarte').style.display = 'block';
    }

    function abrirModalCadastrarModeloEncarte() {
      listaPassosEncarteAtual = [];
      renderizarPassosEncarteLista();
      var selCli = document.getElementById('mCadEncCli');
      var selCatJ = document.getElementById('mCadEncCatJoia');
      selCli.innerHTML = ""; selCatJ.innerHTML = "";
      bancoClientes.forEach(function(c) { selCli.innerHTML += '<option value="' + c.marca + '">' + c.marca + '</option>'; });
      bancoCategoriasJoias.forEach(function(cj) { selCatJ.innerHTML += '<option value="' + cj + '">' + cj + '</option>'; });
      atualizarSelectsInsumosModeloEncarte();
      document.getElementById('modalCadModeloEncarte').style.display = 'flex';
    }

    function fecharModalCadModeloEncarte() { document.getElementById('modalCadModeloEncarte').style.display = 'none'; }

    var listaPassosEncarteAtual = [];
    function adicionarPassoEncarteLista() {
      var inp = document.getElementById('inputPassoEncarteTemp');
      var txt = inp.value.trim();
      if(txt) {
        listaPassosEncarteAtual.push((listaPassosEncarteAtual.length + 1) + ". " + txt);
        inp.value = "";
        renderizarPassosEncarteLista();
      }
    }

    function renderizarPassosEncarteLista() {
      var box = document.getElementById('containerPassosEncarteLista');
      box.innerHTML = listaPassosEncarteAtual.map(function(p, idx) {
        return '<div style="font-size:0.8rem; margin:2px 0; display:flex; justify-content:space-between;">' +
            '<span>' + p + '</span><b style="color:red; cursor:pointer;" onclick="removerPassoEncarte(' + idx + ')">✕</b>' +
          '</div>';
      }).join('') || '<span style="font-size:0.78rem; color:var(--text-muted);">Nenhuma instrução.</span>';
    }

    function removerPassoEncarte(idx) {
      listaPassosEncarteAtual.splice(idx, 1);
      renderizarPassosEncarteLista();
    }

    function atualizarSelectsInsumosModeloEncarte() {
      var cli = document.getElementById('mCadEncCli').value;
      var insumos = bancoInsumosCompletos[cli] || [];
      var selectSaq = document.getElementById('mCadEncSaquinho');
      var selectCar = document.getElementById('mCadEncCartela');
      selectSaq.innerHTML = "<option value='Não utiliza saquinho'>Não Utiliza Saquinho</option>";
      selectCar.innerHTML = "<option value='Não utiliza cartela'>Não Utiliza Cartela</option>";

      insumos.forEach(function(i) {
        if(i.tipo === "Saquinho") selectSaq.innerHTML += '<option value="' + i.tipo + ' ' + i.sub + '">' + i.tipo + ' ' + i.sub + '</option>';
        if(i.tipo === "Cartela") selectCar.innerHTML += '<option value="' + i.tipo + ' ' + i.sub + '">' + i.tipo + ' ' + i.sub + '</option>';
      });
    }

    function salvarModeloEncarteCompletoSubmit(e) {
      e.preventDefault();
      var cli = document.getElementById('mCadEncCli').value;
      var catJ = document.getElementById('mCadEncCatJoia').value;
      var saq = document.getElementById('mCadEncSaquinho').value;
      var car = document.getElementById('mCadEncCartela').value;
      var ff = document.getElementById('mCadEncFotoFrente').value.trim();
      var fv = document.getElementById('mCadEncFotoVerso').value.trim();
      var obs = document.getElementById('mCadEncObs').value;

      if(listaPassosEncarteAtual.length === 0) { alert("⚠️ Adicione ao menos 1 passo!"); return; }

      if(!bancoModelosEncarte[cli]) bancoModelosEncarte[cli] = [];
      bancoModelosEncarte[cli].push({ id: Date.now(), catJoia: catJ, passos: listaPassosEncarteAtual, saquinho: saq, cartela: car, fotoFrente: ff, fotoVerso: fv, obs: obs });
      salvarDadosNovem();

      alert("✅ Modelo registrado!");
      fecharModalCadModeloEncarte();
      renderizarSelecaoClientesEncarte();
    }

    function renderizarCategoriasJoiasCentral() {
      var box = document.getElementById('boxListaCategoriasJoiasCentral');
      box.innerHTML = bancoCategoriasJoias.map(function(cj, idx) {
        return '<span class="tag-setor-btn selected" style="margin:4px;">' + cj + ' <b onclick="excluirCategoriaJoiaCentral(' + idx + ')">✕</b></span>';
      }).join('');
      popularListasDestinatariosAviso();
    }

    function popularListasDestinatariosAviso() {
      var boxCli = document.getElementById('boxSelecaoClientesAviso');
      var boxColab = document.getElementById('boxSelecaoColabAviso');

      if (boxCli) {
        boxCli.innerHTML = bancoClientes.map(function(c) {
          return '<label style="display:block; font-size:0.82rem; font-weight:bold; margin-bottom:4px; cursor:pointer;">' +
                   '<input type="checkbox" class="chk-aviso-cli" value="' + c.marca + '"> ' + c.marca +
                 '</label>';
        }).join('');
      }

      if (boxColab) {
        boxColab.innerHTML = bancoColaboradores.map(function(col) {
          return '<label style="display:block; font-size:0.82rem; font-weight:bold; margin-bottom:4px; cursor:pointer;">' +
                   '<input type="checkbox" class="chk-aviso-colab" value="' + col.nome + '"> ' + col.nome +
                 '</label>';
        }).join('');
      }
    }

    function alternarExibicaoDestinatariosAviso() {
      var tipo = document.getElementById('selectTipoDestinatarioAviso').value;
      var boxCli = document.getElementById('boxSelecaoClientesAviso');
      var boxColab = document.getElementById('boxSelecaoColabAviso');

      boxCli.style.display = (tipo === 'SELECIONAR_CLIENTES') ? 'block' : 'none';
      boxColab.style.display = (tipo === 'SELECIONAR_COLABORADORES') ? 'block' : 'none';
    }

    function cadastrarNovaCategoriaJoiaSubmit() {
      var val = document.getElementById('inputNovaCatJoia').value.trim();
      if(val && bancoCategoriasJoias.indexOf(val) === -1) {
        bancoCategoriasJoias.push(val);
        salvarDadosNovem();
        document.getElementById('inputNovaCatJoia').value = "";
        renderizarCategoriasJoiasCentral();
      }
    }

    function excluirCategoriaJoiaCentral(idx) {
      if(confirm("⚠️ AVISO 1/2: Tem certeza que deseja excluir esta categoria?") && confirm("⚠️ AVISO 2/2: CONFIRMAÇÃO FINAL: Excluir categoria?")) {
        bancoCategoriasJoias.splice(idx, 1);
        salvarDadosNovem();
        renderizarCategoriasJoiasCentral();
      }
    }

    function salvarFatorDivisorSubmit() {
      var val = parseFloat(document.getElementById('inputFatorDivisorDir').value) || 2.1;
      fatorMediaPesoGlobal = val;
      alert("⚙️ Média ajustada para " + val + "g!");
    }

    function salvarAvisoComunicadoSubmit() {
      var tipo = document.getElementById('selectTipoDestinatarioAviso').value;
      var txt = document.getElementById('textoAvisoDir').value.trim();

      if (!txt) {
        alert("⚠️ Por favor, digite o texto do comunicado!");
        return;
      }

      var dataHoje = obterDataHoraAtualFormatada();
      var destinatarios = [];

      if (tipo === 'TODOS') destinatarios.push("TODOS");
      else if (tipo === 'TODOS_CLIENTES') bancoClientes.forEach(function(c) { destinatarios.push(c.marca); });
      else if (tipo === 'TODOS_COLABORADORES') destinatarios.push("EQUIPE");
      else if (tipo === 'SELECIONAR_CLIENTES') {
        var marcados = document.querySelectorAll('.chk-aviso-cli:checked');
        marcados.forEach(function(chk) { destinatarios.push(chk.value); });
      } else if (tipo === 'SELECIONAR_COLABORADORES') {
        var marcadosColab = document.querySelectorAll('.chk-aviso-colab:checked');
        marcadosColab.forEach(function(chk) { destinatarios.push(chk.value); });
      }

      if (destinatarios.length === 0) {
        alert("⚠️ Selecione pelo menos um cliente ou colaborador para enviar!");
        return;
      }

      destinatarios.forEach(function(dest) {
        bancoMensagens.push({
          id: Date.now() + Math.random(),
          remetente: "Diretoria General",
          destinatario: dest,
          texto: txt,
          data: dataHoje
        });
      });

      salvarDadosNovem();
      document.getElementById('textoAvisoDir').value = "";
      alert("📢 Comunicado publicado com sucesso!");
    }

    carregarDadosNovem();
  </script>
</body>
</html>
