LANGUAGE = 'en'

require 'yaml'
MESSAGES = YAML.load_file('loan_calc_messages.yml')

def messages(message, lang = 'en')
  MESSAGES[lang][message]
end

def prompt(key)
  message = messages(key, LANGUAGE)
  puts "=> #{message}"
end

def valid_integer?(num)
  if num.empty? || num.to_i.to_s != num || num.to_i.negative?
    false
  else
    true
  end
end

def valid_float?(num)
  if num.empty? || num.to_f.to_s != num || num.to_f.negative?
    false
  else
    true
  end
end

def calculate_payment(amount, monthly_rate, length_months)
  amount.to_i * (monthly_rate / (1 - (1 + monthly_rate)**(-length_months)))
end
  
system('clear')

prompt('welcome')

loop do
  prompt('loan_amt')

  amount = ''
  loop do
    amount = gets.chomp.gsub('$', '').gsub(',', '')
    if valid_integer?(amount) || valid_float?(amount)
      break
    else
      prompt('negative')
    end
  end

  prompt('apr')

  rate = ''
  loop do
    rate = gets.chomp.gsub('%', '')
    if valid_integer?(amount) || valid_float?(amount)
      break
    else
      prompt('invalid')
    end
  end

  prompt('loan_length')

  length = ''
  loop do
    length = gets.chomp
    if valid_integer?(length) || valid_float?(length)
      break
    else
      prompt('negative')
    end
  end

  annual_rate = rate.to_f / 100
  monthly_rate = annual_rate / 12
  length_months = length.to_f * 12

  monthly_payment = calculate_payment(amount, monthly_rate, length_months)
  
  prompt('calculating')
  sleep(2)
  
  puts format(messages('payment', LANGUAGE), amt: "$#{monthly_payment.round(2)}")

  prompt('again')
  again = gets.chomp

  break unless ['y', 'Y', 'yes', 'Yes', 'YES'].include?(again)
  system('clear')
end

prompt('goodbye')
