import json

def print_all_ids(json_ast):
    regFun = [];

    def process(node):
        # if "id" in node:
        #     print(node["id"])
        # if "name" in node:
        #     print(node["name"])
        if "kind" in node and node["kind"] == "FunctionDecl":
            # funDecl = node.get("FunctionDecl")
            name = node.get("name")
            if "storageClass" in node and node["storageClass"] == "extern":
                print("extern>:"+name)
            else:
                print("declar>:"+name)
        if "referencedDecl" in node:
            refDecl = node.get("referencedDecl")
            fid = refDecl.get("id")
            name = refDecl.get("name")
            print("call>:"+fid+":"+name)
            # called_funcs.append(name)

        if "inner" in node:
            for inner_node in node["inner"]:
                process(inner_node)

    ast_data = json.loads(json_ast)
    process(ast_data)

if __name__ == "__main__":
    with open("clang_ast_output.json", "r") as f:
        json_ast = f.read()
        top_level_functions = print_all_ids(json_ast)
        # print("functions:", top_level_functions)
