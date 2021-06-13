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
  !(num.empty? || num.to_i.to_s != num || num.to_i <= 0)
end

def valid_float?(num)
  !(num.empty? || num.to_f.to_s != num || num.to_f <= 0)
end

def valid_apr?(num)
  !(num.empty? || num.to_i.to_s != num || num.to_i.negative?)
end

def get_loan_amt
  prompt('loan_amt')

  amount = ''
  loop do
    amount = gets.chomp.gsub('$', '').gsub(',', '').gsub('k', '000')
    break if valid_integer?(amount) || valid_float?(amount)
    prompt('negative')
  end

  amount
end

def get_loan_rate
  prompt('apr')

  rate = ''
  loop do
    rate = gets.chomp.gsub('%', '')
    break if valid_apr?(rate)
    prompt('invalid')
  end

  rate
end

def get_loan_length
  prompt('loan_length')

  length = ''
  loop do
    length = gets.chomp
    break if valid_integer?(length) || valid_float?(length)
    prompt('negative')
  end

  length
end

def calculate_payment(amount, monthly_rate, length_months)
  if monthly_rate > 0
    amount.to_i * (monthly_rate / (1 - (1 + monthly_rate)**(-length_months)))
  elsif monthly_rate == 0
    amount.to_i / length_months
  end
end

def display_payment(payment)
  puts format(messages('payment', LANGUAGE),
              amt: "$#{payment.round(2)}")
end

def calculate_again?
  prompt('again')

  loop do
    again = gets.chomp
    if ['y', 'yes'].include?(again.downcase)
      return true
    elsif ['n', 'no'].include?(again.downcase)
      return false
    end
    prompt('invalid_input')
  end
end

def clear
  system('clear')
end

clear

prompt('welcome')

loop do
  amount = get_loan_amt
  rate = get_loan_rate
  length = get_loan_length

  annual_rate = rate.to_f / 100
  monthly_rate = annual_rate / 12
  length_months = length.to_f * 12

  monthly_payment = calculate_payment(amount, monthly_rate, length_months)

  prompt('calculating')
  sleep(2)

  display_payment(monthly_payment)

  break if !(calculate_again?)
end

clear

prompt('goodbye')
