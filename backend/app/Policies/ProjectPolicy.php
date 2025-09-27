<?php
namespace App\Policies;

use App\Models\User;
use App\Models\Project;
use App\Policies\BaseScopedPolicy;

class ProjectPolicy extends BaseScopedPolicy
{
    public function access(User $user, Project $project): bool
    {
        // User must be member of workspace and role must allow area
        return $user->workspaces->contains($project->team_id)
            && parent::access($user, $project->workspace);
    }
}
