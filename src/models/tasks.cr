module Model
    class Task < Crecto::Model

        schema "tasks" do # table name
            field :id, Int32, primary_key: true
            field :job_id, Int32
            field :task, String
            field :description, String
            field :language, String
            field :code, String
            field :active, Int32
        end

        validate_required [:job_id, :task, :language, :code]
    end
end