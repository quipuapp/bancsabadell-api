module BancSabadell
  class AccountTransaction < Base
    attr_accessor :order_number, :operation_date, :value_date,
      :amount, :currency, :accumulated_amount, :concept,
      :concept_code

    def self.generate_url_keyword(product_data)
      "#{product_data[:product_type]}/#{product_data[:product_number]}/movimientos"
    end

    def self.scope_attribute
      :product_data
    end

    def format_amount(amount)
      amount.gsub('.', '').sub(',', '.')
    end

    [ :amount, :accumulated_amount ].each do |m|
      define_method m do
        format_amount(instance_variable_get :"@#{m}")
      end
    end

    def parse_time(time)
      Time.strptime(time, '%F')
    end

    [ :operation_date, :value_date ].each do |m|
      define_method m do
        parse_time(instance_variable_get :"@#{m}")
      end
    end

    def self.attribute_translations
      {
        numOrden: :order_number,
        fechaOperacion: :operation_date,
        fechaValor: :value_date,
        importe: :amount,
        divisa: :currency,
        saldo: :accumulated_amount,
        concepto: :concept,
        codigoConcepto: :concept_code
      }
    end
  end
end
