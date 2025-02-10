require "google/cloud/language"

class GoogleSentimentAnalysis
  def self.analyze(text)
    return "neutral" if text.blank?

    begin
      language = Google::Cloud::Language.language_service
      document = { content: text, type: :PLAIN_TEXT }

      response = language.analyze_sentiment document: document
      sentiment_score = response.document_sentiment.score

      classify_sentiment(sentiment_score)
    rescue StandardError => e
      Rails.logger.error "Erro na análise de sentimento: #{e.message}"
      "neutral" # Fallback seguro em caso de erro
    end
  end

  private

  def self.classify_sentiment(score)
    if score > 0.25
      "positive"
    elsif score < -0.25
      "negative"
    else
      "neutral"
    end
  end
end