HALFPI = 3.14159/2

function collides(e, p)
	return ((e.x < (p.x + p.width)) and
	   ((e.x + e.width) > p.x) and
	   (e.y < (p.y + p.height)) and
	   ((e.y + e.height) > p.y))
end

