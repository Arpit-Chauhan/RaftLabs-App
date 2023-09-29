import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLPage extends StatefulWidget {
  const GraphQLPage();
  @override
  State<GraphQLPage> createState() => _GraphQLPageState();
}

class _GraphQLPageState extends State<GraphQLPage> {
  List<dynamic> characters = [];
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('GraphQL'),
      ),
      body: _loading 
          ? Center(child: const CircularProgressIndicator())
          : characters.isEmpty
              ? Center(
                  child: ElevatedButton(
                    child: const Text("Fetch Data"),
                    onPressed: () {
                      fetchData();
                    },
                  ),
                ) 
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                      itemCount: characters.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Image(
                              image: NetworkImage(
                                characters[index]['image'],
                              ),
                            ),
                            title: Text(
                              characters[index]['name'],
                            ),
                          ),
                        );
                      }), 
                ),
    );
  }

  void fetchData() async {
    setState(() {
      _loading = true; 
    });
    HttpLink link =
        HttpLink("https://rickandmortyapi.com/graphql"); 
    GraphQLClient qlClient = GraphQLClient(
      
      link: link,
      cache: GraphQLCache(
        store:
            HiveStore(),
      ),
    );
    QueryResult queryResult = await qlClient.query(
      QueryOptions(
        document: gql(
          """query {
  characters() {
    results {
      name
      image 
    }
  }
  
}""",
        ),
      ),
    );

// queryResult.data  // contains data
// queryResult.exception // will give exception
    setState(() {
      characters = queryResult.data!['characters'][
          'results']; 
      _loading = false;
    });
  }
}