import 'package:flutter/material.dart';
import '../models/artist.dart';

/// Stateless Artist Header Widget
/// Displays artist profile information
class ArtistHeader extends StatelessWidget {
  final Artist artist;

  const ArtistHeader({
    Key? key,
    required this.artist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Photo
          CircleAvatar(
            radius: 40.0,
            backgroundColor: Colors.grey[200],
            child: artist.profilePhoto.startsWith('http')
                ? ClipOval(
                    child: Image.network(
                      artist.profilePhoto,
                      width: 80.0,
                      height: 80.0,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildPlaceholder();
                      },
                    ),
                  )
                : _buildPlaceholder(),
          ),
          const SizedBox(height: 12.0),
          // Artist Name
          Text(
            artist.name,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4.0),
          // Craft Type
          Text(
            artist.craftType,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8.0),
          // Location
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 16.0,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4.0),
              Text(
                artist.location,
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < artist.rating.floor()
                      ? Icons.star
                      : Icons.star_border,
                  size: 16.0,
                  color: Colors.amber,
                );
              }),
              const SizedBox(width: 8.0),
              Text(
                '${artist.rating.toStringAsFixed(1)} (${artist.reviewCount} reviews)',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Icon(
      Icons.person,
      size: 40.0,
      color: Colors.grey[400],
    );
  }
}
