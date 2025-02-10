require 'selenium-webdriver'

class ReclameAqui
  def self.fetch_company_info(company_name)
    options = Selenium::WebDriver::Chrome::Options.new

    options.add_argument('--headless') # Executa sem abrir o navegador
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-dev-shm-usage')
    options.add_argument('--window-size=1280,1024')

    options.add_argument('--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36')

    driver = Selenium::WebDriver.for(:chrome, options: options)

    begin
      formatted_name = company_name.strip.downcase.gsub(' ', '-')
      url = "https://www.reclameaqui.com.br/empresa/#{formatted_name}"
      puts "🔍 Acessando URL: #{url}"
      driver.get(url)

      wait = Selenium::WebDriver::Wait.new(timeout: 60)

      company_name_element = wait.until { driver.find_element(css: '#titulo_empresa_hero > h1') }
      rating_element = wait.until { driver.find_element(css: '#ra-new-reputation > span > b') }
      reviews_count_element = wait.until { driver.find_element(css: '#tag_reputacao_hero') }

      company_name = company_name_element.text.strip rescue "Nome não encontrado"
      rating = rating_element.text.strip rescue "Nota não disponível"
      reviews_count = reviews_count_element.text.strip rescue "Sem informações"

      result = {
        company_name: company_name,
        rating: rating,
        reviews_count: reviews_count
      }

      puts "✅ Dados coletados: #{result}"
      result
    rescue Selenium::WebDriver::Error::TimeoutError
      puts "❌ Erro: Timeout ao tentar carregar a página ou localizar os seletores."
      { error: "Timeout ao processar as informações da empresa." }
    rescue StandardError => e
      puts "❌ Erro inesperado: #{e.message}"
      { error: "Erro ao processar as informações da empresa." }
    ensure
      driver.quit
    end
  end
end
