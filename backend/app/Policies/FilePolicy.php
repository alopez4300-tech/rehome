<?php
namespace App\Policies;

use App\Models\User;
use App\Models\File;
use App\Policies\BaseScopedPolicy;

class FilePolicy extends BaseScopedPolicy
{
    public function access(User $user, File $file): bool
    {
        return $user->workspaces->contains($file->project->team_id)
            && parent::access($user, $file->project->workspace);
    }
}
