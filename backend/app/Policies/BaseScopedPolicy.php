<?php
namespace App\Policies;

use App\Models\User;
use Illuminate\Database\Eloquent\Model;

abstract class BaseScopedPolicy
{
    /**
     * Determine if the user can view the model.
     */
    public function view(User $user, Model $model): bool
    {
        // Example: Only allow if user is related to the workspace/project
        return $user->hasRole('admin') || $user->id === $model->user_id;
    }

    /**
     * Determine if the user can create the model.
     */
    public function create(User $user): bool
    {
        return $user->hasRole('admin') || $user->hasRole('team');
    }

    /**
     * Determine if the user can update the model.
     */
    public function update(User $user, Model $model): bool
    {
        return $user->hasRole('admin') || $user->id === $model->user_id;
    }

    /**
     * Determine if the user can delete the model.
     */
    public function delete(User $user, Model $model): bool
    {
        return $user->hasRole('admin');
    }
}
