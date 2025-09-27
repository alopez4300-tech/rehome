<?php
namespace Tests\Unit;

use App\Models\User;
use App\Models\Workspace;
use App\Policies\BaseScopedPolicy;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class BaseScopedPolicyTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function admin_can_access_admin_area_if_in_workspace()
    {
        $user = User::factory()->create(['role' => 'admin']);
        $workspace = Workspace::factory()->create();
        $user->workspaces()->attach($workspace);
        $policy = new BaseScopedPolicy();

        // Simulate request to /admin/dashboard
        request()->server->set('REQUEST_URI', '/admin/dashboard');
        $this->assertTrue($policy->access($user, $workspace));
    }

    /** @test */
    public function team_can_access_app_area_if_in_workspace()
    {
        $user = User::factory()->create(['role' => 'team']);
        $workspace = Workspace::factory()->create();
        $user->workspaces()->attach($workspace);
        $policy = new BaseScopedPolicy();

        // Simulate request to /api/app/projects
        request()->server->set('REQUEST_URI', '/api/app/projects');
        $this->assertTrue($policy->access($user, $workspace));
    }
}
