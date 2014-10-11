module BancSabadell
  class Product < Base
    attr_accessor :owner, :description, :user, :iban, :balance,
      :product, :product_number, :product_id

    def self.generate_url_keyword(_=nil)
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
        numeroProductoCodificado: :product_id
      }
    end
  end
end
