<?php
namespace App\Policies;

use App\Models\User;
use App\Models\Task;
use App\Policies\BaseScopedPolicy;

class TaskPolicy extends BaseScopedPolicy
{
    public function access(User $user, Task $task): bool
    {
        return $user->workspaces->contains($task->project->team_id)
            && parent::access($user, $task->project->workspace);
    }
}
