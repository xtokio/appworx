module Controller
    module Tasks
        extend self

        Query = Crecto::Repo::Query

        def all()
          Model::ConnDB.all(Model::Task)
        end

        def active()
          Model::ConnDB.all(Model::Task, Query.where(active: 1))
        end

        def get_by_id(id : Int32)
          Model::ConnDB.all(Model::Task, Query.where(id: id))
        end

        def get_by_job_id(job_id : Int32)
            Model::ConnDB.all(Model::Task, Query.where(active: 1).where(job_id: job_id))
        end
    end
end