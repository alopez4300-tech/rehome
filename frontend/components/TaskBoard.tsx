import React from "react";
import { Button, Card, Input } from "./ui";

const mockUsers = [
	{ id: 1, name: "John Smith", initials: "JS" },
	{ id: 2, name: "Sarah Johnson", initials: "SJ" },
	{ id: 3, name: "Mike Chen", initials: "MC" },
	{ id: 4, name: "Alex Rivera", initials: "AR" },
	{ id: 5, name: "Emma Wilson", initials: "EW" }
];

const initialTasks = [
	{
		id: "1",
		title: "Review architectural plans",
		subtitle: "Ocean View Resort • 123 Beach Blvd, Miami, FL",
		category: "TASK/REDLINE",
		status: "open",
		description:
			"Review the latest architectural plans for the main lobby renovation. Focus on structural changes and code compliance.",
		createdAt: "2025-06-21T10:30:00Z",
		createdBy: { id: 1, name: "John Smith", initials: "JS" },
		assignees: [
			{ id: 2, name: "Sarah Johnson", initials: "SJ" },
			{ id: 3, name: "Mike Chen", initials: "MC" }
		],
		dueDate: "2025-06-30",
		allowClient: false,
		filesCount: 3,
		attachments: [
			{
				id: 1,
				filename: "floor-plan-v2.pdf",
				size: "2.4 MB",
				uploadedBy: "John Smith",
				uploadedAt: "2025-06-21T10:00:00Z"
			},
			{
				id: 2,
				filename: "elevation-drawings.dwg",
				size: "1.8 MB",
				uploadedBy: "Sarah Johnson",
				uploadedAt: "2025-06-21T09:30:00Z"
			}
		],
		activity: [
			{
				id: 1,
				type: "status_change",
				description: "Status changed: draft → open",
				timestamp: "2025-06-21T10:30:00Z",
				user: "John Smith"
			},
			{
				id: 2,
				type: "assignee_added",
				description: "Sarah Johnson assigned to task",
				timestamp: "2025-06-21T10:15:00Z",
				user: "John Smith"
			}
		]
	},
	{
		id: "2",
		title: "Update client on foundation progress",
		subtitle: "Downtown Office Complex • 456 Main St, Boston, MA",
		category: "PROGRESS/UPDATE",
		status: "open",
		description:
			"Prepare weekly progress update for the foundation work including photos and timeline updates.",
		createdAt: "2025-06-20T14:15:00Z",
		createdBy: { id: 3, name: "Mike Chen", initials: "MC" },
		assignees: [{ id: 1, name: "John Smith", initials: "JS" }],
		dueDate: "2025-06-25",
		allowClient: true,
		filesCount: 1,
		attachments: [],
		activity: []
	},
	{
		id: "3",
		title: "Electrical system inspection",
		subtitle: "Ocean View Resort • 123 Beach Blvd, Miami, FL",
		category: "TASK/REDLINE",
		status: "complete",
		description:
			"Complete electrical inspection for floors 1-3 according to local building codes.",
		createdAt: "2025-06-19T09:00:00Z",
		createdBy: { id: 2, name: "Sarah Johnson", initials: "SJ" },
		assignees: [{ id: 4, name: "Alex Rivera", initials: "AR" }],
		dueDate: "2025-06-22",
		allowClient: false,
		filesCount: 0,
		attachments: [],
		activity: []
	}
];

function formatDate(dateString: string): string {
	const date = new Date(dateString);
	return date
		.toLocaleDateString("en-US", {
			month: "short",
			day: "numeric",
			year: "2-digit"
		})
		.replace(",", "");
}

function getAvatarColor(name: string): string {
	const colors = [
		"#ef4444",
		"#f97316",
		"#f59e0b",
		"#eab308",
		"#84cc16",
		"#22c55e",
		"#10b981",
		"#14b8a6",
		"#06b6d4",
		"#0ea5e9",
		"#3b82f6",
		"#6366f1",
		"#8b5cf6",
		"#a855f7",
		"#d946ef",
		"#ec4899",
		"#f43f5e"
	];
	const index = name
		.split("")
		.reduce(
			(acc: number, char: string) => acc + char.charCodeAt(0),
			0
		);
	return colors[index % colors.length];
}

function StatusDot({ status }: { status: string }) {
	return (
		<span
			className="inline-block w-3 h-3 rounded-full mr-2"
			style={{ backgroundColor: status === "open" ? "#1a73e8" : "#137333" }}
		/>
	);
}

function Avatar({ initials, color }: { initials: string; color: string }) {
	return (
		<span
			className="inline-flex items-center justify-center w-7 h-7 rounded-full text-xs font-bold text-white mr-1"
			style={{ backgroundColor: color }}
		>
			{initials}
		</span>
	);
}

export default function TaskBoard() {
	const [tasks] = React.useState(initialTasks);
	const [searchQuery, setSearchQuery] = React.useState("");
	const [showClosed, setShowClosed] = React.useState(false);

	// Group tasks by category
	const groupedTasks: Record<string, typeof initialTasks> = {
		"TASK/REDLINE": tasks.filter(t => t.category === "TASK/REDLINE"),
		"PROGRESS/UPDATE": tasks.filter(t => t.category === "PROGRESS/UPDATE"),
	};

	return (
		<div className="min-h-screen bg-background px-8 py-6">
			{/* Top bar */}
			<div className="flex items-center justify-between mb-6">
				<h1 className="text-2xl font-bold">Task Board</h1>
				<div className="flex items-center gap-2">
					<Input
						placeholder="Search for people, projects, files, tasks, notes..."
						value={searchQuery}
						onChange={e => setSearchQuery(e.target.value)}
						className="w-[340px]"
					/>
					<Button className="bg-blue-600 text-white px-4 py-2 rounded-md">Add Task +</Button>
				</div>
			</div>
			{/* Filters */}
			<div className="flex items-center gap-2 mb-4 text-sm">
				<span className="font-semibold">Group by:</span>
				<Button className="bg-gray-100 text-gray-700 px-3 py-1 rounded-md">Status ▼</Button>
				<Button className="bg-gray-100 text-gray-700 px-3 py-1 rounded-md">Projects ▼</Button>
				<Button className="bg-gray-100 text-gray-700 px-3 py-1 rounded-md">Date Created ▼</Button>
				<Button className="bg-gray-100 text-gray-700 px-3 py-1 rounded-md">Assignee ▼</Button>
				<Button className="bg-gray-100 text-gray-700 px-3 py-1 rounded-md">Created by ▼</Button>
				<div className="ml-auto flex items-center gap-2">
					<Button className="bg-gray-100 text-gray-700 px-3 py-1 rounded-md">+ Add Note</Button>
					<Button className="bg-gray-100 text-gray-700 px-3 py-1 rounded-md">Screen Clip</Button>
					<Button className="bg-gray-100 text-gray-700 px-3 py-1 rounded-md">ToDo</Button>
					<label className="flex items-center gap-1 cursor-pointer">
						<input type="checkbox" checked={showClosed} onChange={e => setShowClosed(e.target.checked)} />
						Completed
					</label>
				</div>
			</div>
			{/* Task Groups */}
			<div className="space-y-8">
				{Object.entries(groupedTasks).map(([group, groupTasks]) => (
					<div key={group}>
						{/* Group Header */}
						<div className="flex items-center gap-2 mb-2">
							<span
								className={`px-3 py-1 rounded-full text-xs font-bold text-white ${group === "TASK/REDLINE" ? "bg-red-600" : "bg-blue-600"}`}
							>
								{group}
							</span>
							<span className="text-xs font-bold bg-gray-100 px-2 py-1 rounded-full">{groupTasks.length}</span>
						</div>
						{/* Table */}
						<div className="overflow-x-auto">
							<table className="min-w-full text-sm">
								<thead>
									<tr className="border-b">
										<th className="text-left py-2 px-2 font-semibold">Name</th>
										<th className="text-left py-2 px-2 font-semibold">Files</th>
										<th className="text-left py-2 px-2 font-semibold">Date Created</th>
										<th className="text-left py-2 px-2 font-semibold">Created by</th>
										<th className="text-left py-2 px-2 font-semibold">Assigned to</th>
									</tr>
								</thead>
								<tbody>
									{groupTasks.map(task => (
										<tr key={task.id} className="border-b hover:bg-gray-50">
											<td className="py-2 px-2">
												<div className="flex items-center gap-2">
													<StatusDot status={task.status} />
													<span className="font-medium">{task.title}</span>
												</div>
												<div className="text-xs text-muted-foreground">{task.subtitle}</div>
											</td>
											<td className="py-2 px-2">
												<Button className="bg-gray-100 text-gray-700 px-2 py-1 rounded-md">+</Button>
											</td>
											<td className="py-2 px-2">{formatDate(task.createdAt)}</td>
											<td className="py-2 px-2">{task.createdBy ? <Avatar initials={task.createdBy.initials} color={getAvatarColor(task.createdBy.name)} /> : null}</td>
											<td className="py-2 px-2">
												<div className="flex items-center gap-1">
													{task.assignees.map(a => (
														<Avatar key={a.id} initials={a.initials} color={getAvatarColor(a.name)} />
													))}
												</div>
											</td>
										</tr>
									))}
								</tbody>
							</table>
						</div>
						<div className="mt-2">
							<Button className="border px-3 py-1 rounded-md">+ Add Task</Button>
						</div>
					</div>
				))}
			</div>
		</div>
	);
}