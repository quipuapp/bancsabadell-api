module BancSabadell
  class Product < Base
    attr_accessor :owner, :description, :user, :iban, :balance,
                  :product, :product_number, :product_id,
                  :currency, :has_more_pages

    def self.generate_url_keyword(_ = nil)
      'productos'
    end

    def self.attribute_translations
      {
        propietario: :owner,
        descripcion: :description,
        usuario: :user,
        iban: :iban,
        balance: :balance,
        producto: :product,
        numeroProducto: :product_number,
        numeroProductoCodificado: :product_id,
        currency: :currency
      }
    end

    def account_transactions(opts = {})
      AccountTransaction.query(opts.merge(product_data: { product_number: product_number,
                                                          product_type: self.class.generate_url_keyword },
                                          more_pages_container: self))
    end
  end
end
