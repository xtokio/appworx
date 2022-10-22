module Model
    class TaskStatus < Crecto::Model

        schema "task_status" do # table name
            field :id, Int32, primary_key: true
            field :job_id, Int32
            field :task_id, Int32
            field :status, String
            field :response, String
        end

        validate_required [:job_id, :task_id]
    end
end