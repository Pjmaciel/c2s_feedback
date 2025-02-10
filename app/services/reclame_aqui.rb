require 'puppeteer'

class ReclameAqui
  def self.fetch_company_info(company_name)
    browser = nil
    page = nil
    begin
      # Inicia o navegador
      browser = Puppeteer.launch(headless: false) # Modo não headless para depuração
      page = browser.new_page

      # Configurações para evitar bloqueios
      page.set_user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36")
      page.viewport = Puppeteer::Viewport.new(width: 1280, height: 1024)

      # Acessa a página da empresa
      url = "https://www.reclameaqui.com.br/empresa/#{company_name}"
      puts "Tentando acessar URL: #{url}"
      page.goto(url, wait_until: 'networkidle2', timeout: 120000) # Aumenta o timeout para 120 segundos

      # Espera o carregamento do conteúdo
      puts "Página carregada. Procurando pelos seletores..."
      page.wait_for_selector('#titulo_empresa_hero > h1', timeout: 120000) # Aumenta o timeout para 120 segundos

      # Extrai informações
      company_name = page.eval_on_selector('#titulo_empresa_hero > h1', 'el => el.textContent')
      rating = page.eval_on_selector('#ra-new-reputation > span > b', 'el => el.textContent')
      reviews_count = page.eval_on_selector('#tag_reputacao_hero', 'el => el.textContent')

      {
        company_name: company_name.strip,
        rating: rating.strip,
        reviews_count: reviews_count.strip
      }
    rescue Puppeteer::TimeoutError => e
      puts "Erro: Timeout ao tentar carregar a página ou localizar o seletor."
      { error: "Timeout ao processar as informações da empresa." }
    rescue Puppeteer::ProtocolError => e
      puts "Erro de protocolo: #{e.message}"
      { error: "Erro de comunicação com o navegador." }
    rescue StandardError => e
      puts "Erro inesperado: #{e.message}"
      { error: "Ocorreu um erro ao processar as informações da empresa." }
    ensure
      # Fecha a página e o navegador, se estiverem abertos
      page.close if page
      browser.close if browser
    end
  end
end