module Controller
    module Users
        extend self

        Query = Crecto::Repo::Query

        def all()
            Model::ConnDB.all(Model::User)
        end

        def login(env)
          username = env.params.json["username"].as(String)
          password = env.params.json["password"].as(String)
          
          env.session.bool("is_admin", false)

          records = Model::ConnDB.all(Model::User, Query.where(username: username, password: password).where(active: 1))

          if records.size > 0
            records.each do |record|
              env.session.int("login", record.id.to_s.to_i)
              env.session.string("user_id", record.id.to_s)
              env.session.string("user_name", record.name.to_s)
              env.session.string("account_type", record.account_type.to_s)

              if record.account_type.to_s == "Administrator"
                env.session.bool("is_admin", true)
              end
            end
          end
          puts "Users::Login #{env.session.int("login")}"
        end

        def get_by_id(id : String)
            Model::ConnDB.all(Model::User, Query.where(id: id))
        end

        def create(env)
            username     = env.params.json["username"].as(String)
            password     = env.params.json["password"].as(String)
            name         = env.params.json["name"].as(String)
            account_type = env.params.json["account_type"].as(String)
            
            user_record = Model::User.new
            user_record.username     = username
            user_record.password     = password
            user_record.name         = name
            user_record.account_type = account_type
            user_record.active    = 1
            changeset = Model::ConnDB.insert(user_record)

            user_id = changeset.instance.id

            {status: "OK",id: user_id, message: "User : #{user_id} was created."}.to_json
        end

        def update(env)
            id           = env.params.json["id"].as(String)
            username     = env.params.json["username"].as(String)
            password     = env.params.json["password"].as(String)
            name         = env.params.json["name"].as(String)
            account_type = env.params.json["account_type"].as(String)
            active       = env.params.json["active"].as(String)

            user_record = Model::ConnDB.get!(Model::User, id)
            user_record.username     = username
            user_record.password     = password
            user_record.name         = name
            user_record.account_type = account_type
            user_record.active       = active.to_i
            changeset = Model::ConnDB.update(user_record)

            {status: "OK",id: id, message: "User : #{id} was updated."}.to_json
        end

        def activate(id : String)
            user_record = Model::ConnDB.get!(Model::User, id)
            user_record.active = 1
            changeset = Model::ConnDB.update(user_record)

            {status: "OK",id: id, message: "User is now Active."}.to_json
        end

        def deactivate(id : String)
            user_record = Model::ConnDB.get!(Model::User, id)
            user_record.active = 0
            changeset = Model::ConnDB.update(user_record)

            {status: "OK",id: id, message: "User is now Inactive."}.to_json
        end

    end
end