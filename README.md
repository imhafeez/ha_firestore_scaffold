<!-- 
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-1-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->


<!-- <p align="center">
	<img src="https://raw.githubusercontent.com/imhafeez/ha_firestore_scaffold/master/assets/logo.png" height="80" alt="Focus Detector Logo" />
</p> -->
<p align="center">
	<a href="https://pub.dev/packages/ha_firestore_scaffold"><img src="https://img.shields.io/pub/v/ha_firestore_scaffold.svg" alt="Pub.dev Badge"></a>
	<!-- <a href="https://github.com/imhafeez/ha_firestore_scaffold/actions"><img src="https://github.com/imhafeez/ha_firestore_scaffold/workflows/build/badge.svg" alt="GitHub Build Badge"></a> -->
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
	<a href="https://github.com/imhafeez/ha_firestore_scaffold"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Flutter Platform Badge"></a>
</p>

# Firestore Scaffold 
Just like material Scaffold this Firestore Scaffold designed specifically for firestore which displays realtime paginated list view or gird view based on screensize. You can also add Search feature based on query as well.

## Features

- 📱 Firestore Scaffold
- 🔎 Search with query
- 📈 Firestore Realtime pagination
- 𝍌 List view style
- ⌗ Grouped List View
- 🌊 Waterflow Grid view style


---
## Getting started

Add dependency
```
dependencies:
  ha_firestore_scaffold: # latest version

```

## Usage

Use ``` HAFirestoreScafold ``` as a normal scaffold to get a realtime paginated result from firestore query.

```dart
    HAFirestoreScafold(
      title: widget.title,
      query: FirebaseFirestore.instance
          .collection("users")
          .orderBy("addedDate", descending: true),
      limit: (deviceType) {
        return 50;
      },
      itembuilder: (context, snapshot) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return ListTile(
          title: Text(data['name'] ?? "no name"),
        );
      },
      emptyWidget: const Center(
        child: Text("no data found"),
      ),
    )
```

### Search 
You can have a search in the scaffold as well by using ``` HAFirestoreSearch ``` as a ``` searchDelegate ``` where ``` searchField ``` will be a document field with array of strings

```dart
  HAFirestoreSearch(
    firestoreQuery: FirebaseFirestore.instance
        .collection("users")
        .orderBy("addedDate", descending: true),
    searchField: 'keywords',
    builder: (context, snapshot) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return ListTile(
        title: Text(data['name'] ?? "no name"),
      );
    },
    emptyWidget: const Center(
      child: Text("no search data found"),
    ),
  )
```
### Grouping (Sticky Headers)

You can group your listing by passing ``` groupBy ``` field and your ``` header ``` widget in the ``` HAFirestoreScafold ``` constructor.

```dart
  HAFirestoreScafold(
    ...
    groupBy: "addedDate",
    header: (groupFieldValue) {
      return Container(
        color: Colors.white,
        child: Text("$groupFieldValue"),
      );
    },
    ...
  )
```

---
## Contributors ✨

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/imhafeez"><img src="https://avatars.githubusercontent.com/u/21155655?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Hafeez Ahmed</b></sub></a><br /><a href="https://github.com/imhafeez/ha_firestore_scaffold/commits?author=imhafeez" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->

This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an issue. If you fixed a bug or implemented a feature, please send a pull request.
