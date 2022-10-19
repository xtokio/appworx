module Model
    class Job < Crecto::Model

        schema "jobs" do # table name
            field :id, Int32, primary_key: true
            field :user_id, Int32
            field :job, String
            field :description, String
            field :schedule, String
            field :schedule_time, String
            field :active, Int32
        end

        validate_required [:user_id, :job, :schedule, :schedule_time]
    end
end