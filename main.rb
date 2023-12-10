require 'net/http'
require 'json'
require 'uri'

# API URL
url = URI("https://api.coincap.io/v2/assets")

# İzlenecek para birimleri
izlenecek_para_birimleri = ["BTC", "ETH", "USDT", "BNB", "SOL"]

def move_cursor_up(lines)
  # Terminalde imleci belirtilen satır kadar yukarı taşı
  print "\033[#{lines}A"
end

def clear_screen
  # Terminalde ekranı temizle
  print "\033[2J"
end

def clear_line
  # Terminalde mevcut satırı temizle
  print "\033[K"
end

while true
  # API'den veri çekme
  response = Net::HTTP.get(url)
  data = JSON.parse(response)

  # İzlenecek para birimlerinin verilerini işleme
  formatted_data = []
  data["data"].each do |currency|
    if izlenecek_para_birimleri.include? currency["symbol"]
      symbol = currency["symbol"]
      price_usd = currency["priceUsd"].to_f
      formatted_price = format('%.2f', price_usd)
      formatted_data << "#{symbol}: #{formatted_price}"
    end
  end

  # Ekranı temizle ve 100ms bekle
  clear_screen
  sleep(0.1)

  # İmleci yukarı taşı ve satırları güncelle
  if formatted_data.length > 0
    move_cursor_up(formatted_data.length)
  end
  formatted_data.each do |line|
    clear_line
    puts line
  end

  # 5 saniye bekle
  sleep(5)
end