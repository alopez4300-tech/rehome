<?php
namespace App\Policies;

use App\Models\User;
use App\Models\Comment;
use App\Policies\BaseScopedPolicy;

class CommentPolicy extends BaseScopedPolicy
{
    public function access(User $user, Comment $comment): bool
    {
        return $user->workspaces->contains($comment->project->team_id)
            && parent::access($user, $comment->project->workspace);
    }
}
