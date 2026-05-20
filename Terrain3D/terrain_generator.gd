extends MultiMeshInstance3D

@export var size: int = 100
@export var scale_world: float = 2.0
@export var height: float = 10.0

func _ready() -> void:
	var box_mesh: BoxMesh = BoxMesh.new()
	box_mesh.size = Vector3(2, 2, 2)

	var mat: StandardMaterial3D = StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.8, 0.2)
	box_mesh.material = mat

	var mm: MultiMesh = MultiMesh.new()
	mm.mesh = box_mesh
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.instance_count = size * size
	self.multimesh = mm

	var noise: FastNoiseLite = FastNoiseLite.new()
	noise.seed = randi()
	noise.frequency = 0.05

	for x: int in range(size):
		for z: int in range(size):
			var index: int = x * size + z
			var y: float = noise.get_noise_2d(x, z) * height
			var pos: Vector3 = Vector3(x * scale_world, y, z * scale_world)
			var transform_3d: Transform3D = Transform3D(Basis(), pos)
			mm.set_instance_transform(index, transform_3d)

			var static_body: StaticBody3D = StaticBody3D.new()
			static_body.position = pos

			var collision_shape: CollisionShape3D = CollisionShape3D.new()
			var box_shape: BoxShape3D = BoxShape3D.new()
			box_shape.size = Vector3(2, 2, 2)

			collision_shape.shape = box_shape
			static_body.add_child(collision_shape)
			get_parent().call_deferred("add_child", static_body)
