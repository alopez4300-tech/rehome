<?php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\Workspace;

class ScopeWorkspace
{
    public function handle(Request $request, Closure $next)
    {
        $user = Auth::user();
        $workspaceId = $request->route('workspace');
        if (! $workspaceId || ! $user->workspaces->contains($workspaceId)) {
            abort(403, 'Workspace access denied');
        }
        return $next($request);
    }
}
