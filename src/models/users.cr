module Model
    class User < Crecto::Model

        schema "users" do # table name
            field :id, Int32, primary_key: true
            field :username, String
            field :password, String
            field :name, String
            field :account_type, String
            field :active, Int32
        end

        validate_required [:username, :password, :account_type]
    end
end