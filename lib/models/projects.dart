import 'package:mobile_app/locator.dart';
import 'package:mobile_app/models/collaborators.dart';
import 'package:mobile_app/models/links.dart';
import 'package:mobile_app/services/local_storage_service.dart';

class Projects {
  factory Projects.fromJson(Map<String, dynamic> json) => Projects(
        data: List<Project>.from(json['data'].map((x) => Project.fromJson(x))),
        links: Links.fromJson(json['links']),
      );

  Projects({
    this.data,
    this.links,
  });
  List<Project> data;
  Links links;
}

class Project {
  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] ?? json['data']['id'],
        type: json['type'] ?? json['data']['type'],
        attributes: ProjectAttributes.fromJson(
            json['attributes'] ?? json['data']['attributes']),
        relationships: ProjectRelationships.fromJson(
            json['relationships'] ?? json['data']['relationships']),
        collaborators: json['included'] != null
            ? List<Collaborator>.from(
                json['included']
                    ?.where((e) => e['type'] == 'user')
                    ?.map((e) => Collaborator.fromJson(e)),
              )
            : null,
      );
  Project({
    this.id,
    this.type,
    this.attributes,
    this.relationships,
    this.collaborators,
  });
  String id;
  String type;
  ProjectAttributes attributes;
  ProjectRelationships relationships;
  List<Collaborator> collaborators;

  bool get hasAuthorAccess {
    var currentUser = locator<LocalStorageService>().currentUser;

    if (currentUser != null) {
      return relationships.author.data.id == currentUser.data.id;
    }

    return false;
  }
}

class ProjectAttributes {
  factory ProjectAttributes.fromJson(Map<String, dynamic> json) =>
      ProjectAttributes(
        name: json['name'],
        projectAccessType: json['project_access_type'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        imagePreview: ImagePreview.fromJson(json['image_preview']),
        description: json['description'],
        view: json['view'],
        tags: List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))),
        isStarred: json['is_starred'],
        authorName: json['author_name'],
        starsCount: json['stars_count'],
      );
  ProjectAttributes({
    this.name,
    this.projectAccessType,
    this.createdAt,
    this.updatedAt,
    this.imagePreview,
    this.description,
    this.view,
    this.tags,
    this.isStarred,
    this.authorName,
    this.starsCount,
  });

  String name;
  String projectAccessType;
  DateTime createdAt;
  DateTime updatedAt;
  ImagePreview imagePreview;
  String description;
  int view;
  List<Tag> tags;
  bool isStarred;
  String authorName;
  int starsCount;
}

class ImagePreview {
  factory ImagePreview.fromJson(Map<String, dynamic> json) => ImagePreview(
        url: json['url'],
      );
  ImagePreview({
    this.url,
  });

  String url;
}

class ProjectRelationships {
  factory ProjectRelationships.fromJson(Map<String, dynamic> json) =>
      ProjectRelationships(
        author: Author.fromJson(json['author']),
      );

  ProjectRelationships({
    this.author,
  });
  Author author;
}

class Author {
  factory Author.fromJson(Map<String, dynamic> json) => Author(
        data: AuthorData.fromJson(json['data']),
      );

  Author({
    this.data,
  });
  AuthorData data;
}

class AuthorData {
  factory AuthorData.fromJson(Map<String, dynamic> json) => AuthorData(
        id: json['id'],
        type: json['type'],
      );

  AuthorData({
    this.id,
    this.type,
  });
  String id;
  String type;
}

class Tag {
  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json['id'],
        name: json['name'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Tag({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });
  int id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
}
