using SDDP

abstract type Task end
abstract type TaskArtifact end

"""
run(t::Task, a::Vector{TaskArtifact})

Runs a task that was required for a given entrypoint.
"""
function run(t::Task, a::Vector{TaskArtifact})::Union{TaskArtifact,Nothing} end

"""
write(a::TaskArtifact)

Write the task results given an artifact.
"""
function write(a::TaskArtifact) end

struct Policy <: Task
    inputs::Inputs
end
struct PolicyArtifact <: TaskArtifact
    policy::SDDP.PolicyGraph
end

function run(t::Policy, a::Vector{TaskArtifact})::Union{PolicyArtifact,Nothing}
    # Calls build_model and train_model 
end

function write(a::PolicyArtifact)
    # Write cuts to file
end

struct Simulation <: Task
    inputs::Inputs
end
struct SimulationArtifact <: TaskArtifact
    simulations::Vector{Vector{Dict{Symbol,Any}}}
end

function run(t::Simulation, a::Vector{TaskArtifact})::Union{SimulationArtifact,Nothing}
    # Calls simulate_model
end

function write(a::SimulationArtifact)
    # Write simulation results to file
end

function read_validate_tasks!(
    t::Vector{String}, inputs::Inputs, e::CompositeException
)::Vector{Task}
    task_objs = Vector{Task}()
    try
        task_type = getfield(@__MODULE__, Symbol(t))
        task_obj = task_type(inputs)
        push!(task_objs, task_obj)
    catch
        push!(e, AssertionError("Task kind ($kind) not recognized"))
    end
    return task_objs
end

function run_tasks(tasks::Vector{Task}, e::CompositeException)::Vector{TaskArtifact}
    artifacts = Vector{TaskArtifact}()
    for task in tasks
        a = run(task, artifacts)
        a !== nothing || push!(e, AssertionError("Task $task failed"))
        push!(artifacts, a)
    end
    return artifacts
end