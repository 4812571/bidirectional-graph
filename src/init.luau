type Node = any
type Edge = any

local BiGraph = {}
BiGraph.__index = BiGraph

function BiGraph.new()
    local self = setmetatable({}, BiGraph)
    self._outEdges = {}
    self._inEdges = {}
end

function BiGraph:AddEdge(node1: Node, node2: Node, edge: Edge)
    if not self._outEdges[node1] then
        self._outEdges[node1] = {}
    end

    if not self._inEdges[node2] then
        self._inEdges[node2] = {}
    end

    self._outEdges[node1][node2] = edge
    self._inEdges[node2][node1] = edge
end

function BiGraph:RemoveEdge(node1: Node, node2: Node)
    if self._outEdges[node1] then
        self._outEdges[node1][node2] = nil

        if not next(self._outEdges[node1]) then
            self._outEdges[node1] = nil
        end    
    end

    if self._inEdges[node2] then
        self._inEdges[node2][node1] = nil

        if not next(self._inEdges[node2]) then
            self._inEdges[node2] = nil
        end
    end
end

function BiGraph:RemoveNode(node)
    -- Remove all inward edges that this node points to
    if self._outEdges[node] then
        for _, otherNode in self._outEdges[node] do
            self._inEdges[otherNode][node] = nil
        
            if not next(self._inEdges[otherNode]) then
                self._inEdges[otherNode] = nil
            end
        end
    end

    -- Remove all outward edges that point to this node
    if self._inEdges[node] then
        for _, otherNode in self._inEdges[node] do
            self._outEdges[otherNode][node] = nil
        
            if not next(self._outEdges[otherNode]) then
                self._outEdges[otherNode] = nil
            end
        end
    end

    -- Remove the node
    self._inEdges[node] = nil
    self._outEdges[node] = nil
end

function BiGraph:GetOutNodes(): {[Node]: {[Node]: Edge}}
    return self._outEdges
end

function BiGraph:GetInNodes(): {[Node]: {[Node]: Edge}}
    return self._inEdges
end

function BiGraph:GetOutEdges(node: Node): {[Node]: Edge}
    if not self._outEdges[node] then
        return {}
    end

    return self._outEdges[node]
end

function BiGraph:GetInEdges(node: Node): {[Node]: Edge}
    if not self._inEdges[node] then
        return {}
    end

    return self._inEdges[node]
end

function BiGraph:GetEdge(node1: Node, node2: Node): Edge
    if not self._outEdges[node1] then
        return nil
    end

    return self._outEdges[node1][node2]
end

function BiGraph:HasEdge(node1: Node, node2: Node): boolean
    if not self._outEdges[node1] then
        return false
    end

    return self._outEdges[node1][node2] ~= nil
end

return BiGraph