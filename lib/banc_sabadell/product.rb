module BancSabadell
  class Product < Base
    #include BancSabadell::Operations::Delete
    #include BancSabadell::Operations::Update

    attr_accessor :owner, :description, :user, :iban, :balance, :product, :product_number, :product_id

    def self.url_keyword
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