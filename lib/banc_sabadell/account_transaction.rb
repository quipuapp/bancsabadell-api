module BancSabadell
  class AccountTransaction < Base
    attr_accessor :order_number, :operation_date, :value_date,
      :amount, :currency, :accumulated_amount, :concept,
      :concept_code

    def self.generate_url_keyword(product_number)
      "cuentasvista/#{product_number}/movimientos"
    end

    def self.scope_attribute
      :product_number
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
